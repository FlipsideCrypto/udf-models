{% macro sp_add_abi_for_decoding(target_schema) -%}
    CREATE
    OR REPLACE PROCEDURE {{ target_schema }}.sp_add_contract_for_decoding(
        contract_address VARCHAR,
        blockchain VARCHAR,
        discord_username VARCHAR,
        abi VARCHAR
    ) returns VARCHAR NOT NULL LANGUAGE SQL AS $$
BEGIN
    CREATE TABLE if NOT EXISTS ethereum.bronze_public.user_abis(
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
        WHEN (
            :CONTRACT_ADDRESS IS NULL
            OR :BLOCKCHAIN IS NULL
            OR :ABI IS NULL
            OR :discord_username IS NULL
        ) THEN RETURN 'ERROR: Please provide all four inputs';
        WHEN (
            (
                SELECT
                    1
                FROM
                    ethereum.silver.abis
                WHERE
                    abi_hash = CONCAT(LOWER(:contract_address), '-', SHA2(PARSE_JSON(:ABI)))) = 1
            ) THEN
            INSERT INTO
                ethereum.bronze_public.user_abis (
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
                ethereum.bronze_public.user_abis (
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
