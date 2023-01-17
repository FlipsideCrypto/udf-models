{% macro create_udfs() %}
    {% if var("UPDATE_UDFS_AND_SPS") %}
        {% set sql %}
        CREATE schema if NOT EXISTS silver;
{% endset %}
        {% do run_query(sql) %}
        {% set sql %}
        {{ create_udf_call_node() }}
        {{ create_udf_call_read_batching() }}
        {{ create_udf_api() }}
        {{ create_udf_hex_to_int(
            schema = "streamline"
        ) }}
        {{ create_udf_transform_logs(
            schema = "streamline"
        ) }}
        {{ create_udf_hex_to_int_with_inputs(
            schema = "streamline"
        ) }}
        {{ create_udf_decode_array_string() }}
        {{ create_udf_decode_array_object() }}

        {% endset %}
        {% do run_query(sql) %}
    {% endif %}
{% endmacro %}
