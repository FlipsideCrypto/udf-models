{% macro create_aws_udfs_api() %}
    {% if target.name == "prod" %}
        {% set sql %}
        CREATE api integration IF NOT EXISTS aws_udf_api api_provider = aws_api_gateway api_aws_role_arn = 'arn:aws:iam::490041342817:role/snowflake-api-udfs' api_allowed_prefixes = (
            'https://smro9shis5.execute-api.us-east-1.amazonaws.com/dev/',
            'https://nvbe90pdg3.execute-api.us-east-1.amazonaws.com/prod/'
        ) enabled = TRUE;
{% endset %}
        {% do run_query(sql) %}
    {% endif %}
{% endmacro %}
