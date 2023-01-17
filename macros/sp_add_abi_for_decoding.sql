{% macro sp_add_abi_for_decoding() -%}
    CREATE
    OR REPLACE PROCEDURE streamline.sp_add_contract_for_decoding(
        contract_address VARCHAR,
        blockchain VARCHAR,
        discord_username VARCHAR,
        abi VARCHAR
    ) returns VARCHAR NOT NULL LANGUAGE SQL AS $$
BEGIN
    CREATE schema if NOT EXISTS udfs_dev.bronze_public;
CREATE TABLE if NOT EXISTS udfs_dev.bronze_public.user_abis(
        contract_address VARCHAR,
        blockchain VARCHAR,
        abi VARCHAR,
        discord_username VARCHAR,
        _INSERTED_TIMESTAMP TIMESTAMP,
        duplicate_abi BOOLEAN
    );
CASE
        WHEN (LENGTH(:CONTRACT_ADDRESS) <> 42
        OR NOT REGEXP_LIKE(:CONTRACT_ADDRESS, '0x[a-fA-f0-9]*')) THEN RETURN 'ERROR: Check your contract address format';
        WHEN (LOWER(:BLOCKCHAIN) NOT IN ('ethereum')) THEN RETURN 'ERROR: Unsupported blockchain';
        WHEN (CHECK_JSON(:ABI) IS NOT NULL) THEN RETURN 'ERROR: ABI is not valid JSON format';
        WHEN (LENGTH(:ABI :: STRING) <= 1
        OR LENGTH(:discord_username :: STRING) <= 1) THEN RETURN 'ERROR: Please provide all four inputs';
        WHEN (
            (
                SELECT
                    1
                FROM
                    udfs_dev.silver.abis
                WHERE
                    contract_address = LOWER(:contract_address)
                    AND blockchain = LOWER(:BLOCKCHAIN)
            ) = 1
        ) THEN
        INSERT INTO
            udfs_dev.bronze_public.user_abis (
                contract_address,
                blockchain,
                abi,
                discord_username,
                _INSERTED_TIMESTAMP,
                duplicate_abi
            )
        SELECT
            LOWER(:CONTRACT_ADDRESS),
            LOWER(:BLOCKCHAIN),
            PARSE_JSON(:ABI),
            :discord_username,
            SYSDATE() :: TIMESTAMP,
            TRUE AS duplicate_abi;
            ELSE
        INSERT INTO
            udfs_dev.bronze_public.user_abis (
                contract_address,
                blockchain,
                abi,
                discord_username,
                _INSERTED_TIMESTAMP,
                duplicate_abi
            )
        SELECT
            LOWER(:CONTRACT_ADDRESS),
            LOWER(:BLOCKCHAIN),
            PARSE_JSON(:ABI),
            :discord_username,
            SYSDATE() :: TIMESTAMP,
            FALSE AS duplicate_abi;
    END;
RETURN 'SUCCESS: ABI added to the decoding queue. Logs should be decoded within 24 hours';
END;$$;
{%- endmacro %}
