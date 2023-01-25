{% macro create_udf_call_read_batching() %}
    CREATE EXTERNAL FUNCTION IF NOT EXISTS streamline.udf_json_rpc_read_calls(
        node_url VARCHAR,
        headers OBJECT,
        calls ARRAY
    ) returns variant api_integration = aws_udf_api AS {% if target.name == "prod" %}
        'https://nvbe90pdg3.execute-api.us-east-1.amazonaws.com/prod/call_read_batching'
    {% else %}
        'https://smro9shis5.execute-api.us-east-1.amazonaws.com/dev/call_read_batching'
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

{% macro create_udf_call_node() %}
    CREATE OR REPLACE EXTERNAL FUNCTION streamline.udf_call_node(secret_name VARCHAR, node_url VARCHAR, headers OBJECT, json_data ARRAY) returns variant api_integration = aws_udf_api AS {% if target.name == "prod" %}
        'https://nvbe90pdg3.execute-api.us-east-1.amazonaws.com/prod/udf_call_node'
    {% else %}
        'https://smro9shis5.execute-api.us-east-1.amazonaws.com/dev/udf_call_node'
    {%- endif %};
{% endmacro %}
