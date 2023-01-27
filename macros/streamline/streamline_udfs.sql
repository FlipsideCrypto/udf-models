{% macro create_udf_call_read_batching() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_json_rpc_read_calls(
        secret_name VARCHAR,
        node_url VARCHAR,
        headers OBJECT,
        calls ARRAY
    ) returns variant api_integration = aws_udf_api AS {% if target.name == "prod" %}
        'https://nvbe90pdg3.execute-api.us-east-1.amazonaws.com/prod/call_read_batching'
    {% else %}
        'https://smro9shis5.execute-api.us-east-1.amazonaws.com/dev/call_read_batching'
    {%- endif %};
{% endmacro %}

{% macro create_udf_call_node() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_json_rpc_call(
        node_url VARCHAR,
        headers OBJECT,
        DATA ARRAY
    ) returns variant api_integration = aws_udf_api AS {% if target.name == "prod" %}
        'https://nvbe90pdg3.execute-api.us-east-1.amazonaws.com/prod/call_node'
    {% else %}
        'https://smro9shis5.execute-api.us-east-1.amazonaws.com/dev/call_node'
    {%- endif %};
{% endmacro %}

{% macro create_udf_api() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_api(
        method VARCHAR,
        url VARCHAR,
        headers OBJECT,
        DATA OBJECT
    ) returns variant api_integration = aws_udf_api AS {% if target.name == "prod" %}
        'https://nvbe90pdg3.execute-api.us-east-1.amazonaws.com/prod/udf_api'
    {% else %}
        'https://smro9shis5.execute-api.us-east-1.amazonaws.com/dev/udf_api'
    {%- endif %};
{% endmacro %}

{% macro create_udf_hex_encode_function() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_hex_encode_function(
        STRING VARCHAR
    ) returns text api_integration = aws_udf_api AS {% if target.name == "prod" %}
        'https://nvbe90pdg3.execute-api.us-east-1.amazonaws.com/prod/udf_hex_encode_function'
    {% else %}
        'https://smro9shis5.execute-api.us-east-1.amazonaws.com/dev/udf_hex_encode_function'
    {%- endif %};
{% endmacro %}
