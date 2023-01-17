{% macro create_sps() %}
    {% if var("UPDATE_UDFS_AND_SPS") %}
        {% if target.database == 'UDFS' %}
            CREATE schema IF NOT EXISTS _internal;
{{ sp_create_prod_clone('_internal') }};
{{ sp_add_abi_for_decoding() }};
        {% endif %}
    {% endif %}
{% endmacro %}
