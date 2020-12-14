#
# Export given tables from BigQuery to Google Storage
#

import os

# export_cmd = 'bq --location=US extract --destination_format=CSV --compression=NONE --field_delimiter=\t --print_header=TRUE \
#                 {proj}:{db}.{table} gs://{bucket}/csv/{prefix}{table}/*{ext}'

# variables

destination_formats = [
    {
        "id": "avro",
        "more_params": "--use_avro_logical_types"
    },
    {
        "id": "csv",
        "more_params": "--field_delimiter=\",\" --print_header=TRUE"
    }
]

# data
bq_project = 'odysseus-mimic-dev'
bq_dataset = 'mimiciv_cdm_tuf_10_ant_2020_10_21'
bq_table_prefix = 'cdm_'
bq_tables = [
        'person',
        'death'
    ]

# gs destination
gs_bucket_path = 'gs://mimic_iv_to_omop/export_cdm'
gs_file_prefix = ''

export_cmd_multdir = 'bq --location=US extract --destination_format={format_u} --compression=NONE {more_params} \
                {proj}:{db}.{prefix_source}{table} {bucket_path}/{format_l}/{prefix_dest}{table}/*{ext}'
export_cmd_onedir = 'bq --location=US extract --destination_format={format_u} --compression=NONE {more_params} \
                {proj}:{db}.{prefix_source}{table} {bucket_path}/{format_l}/{prefix_dest}{table}-*{ext}'

# final destination
local_destination_path = '../export_cdm'
copy_cmd_multdir = 'gsutil cp {bucket_path}/{format_l}/{prefix_dest}{table}/*{ext} {local_path}/{format_l}/{prefix_dest}{table}/'
copy_cmd_onedir = 'gsutil cp {bucket_path}/{format_l}/{prefix_dest}{table}-*{ext} {local_path}/{format_l}/'

# func

def mkdir_if_needed(p):    
    if not os.path.isdir(p):
        bqc = 'mkdir {0}'.format(p)
        print(bqc)    
        rc = os.system(bqc)
        if rc != 0: exit(rc)


# iterate through both formats

for d in destination_formats:

    # if d["id"] == 'avro': continue

    destination_format = d["id"]
    more_params = d["more_params"]

    # create path if not exists

    mkdir_if_needed(local_destination_path)
    mkdir_if_needed('{0}/{1}'.format(local_destination_path, destination_format))

    # gs destination

    for bq_table in bq_tables:

        bqc = export_cmd_onedir.format(
                format_u = destination_format.upper(), format_l = destination_format.lower(),
                more_params = more_params,
                proj = bq_project, db = bq_dataset, prefix_source = bq_table_prefix, table = bq_table,
                bucket_path = gs_bucket_path, prefix_dest = gs_file_prefix,
                ext = '.' + destination_format
            )
        print(bqc)
        rc = os.system(bqc)
        if rc != 0: exit(rc)

        bqc = export_cmd_multdir.format(
                format_u = destination_format.upper(), format_l = destination_format.lower(),
                more_params = more_params,
                proj = bq_project, db = bq_dataset, prefix_source = bq_table_prefix, table = bq_table,
                bucket_path = gs_bucket_path, prefix_dest = gs_file_prefix,
                ext = '.' + destination_format
            )
        print(bqc)
        rc = os.system(bqc)
        if rc != 0: exit(rc)

    # final destination

    for bq_table in bq_tables:

        mkdir_if_needed('{0}/{1}/{2}{3}'.format(
            local_destination_path, destination_format, gs_file_prefix, bq_table))

        bqc = copy_cmd_onedir.format(
                format_l = destination_format.lower(),
                table = bq_table,
                bucket_path = gs_bucket_path,
                prefix_dest = gs_file_prefix,
                ext = '.' + destination_format,
                local_path = local_destination_path
            )
        print(bqc)
        rc = os.system(bqc)
        if rc != 0: exit(rc)


        bqc = copy_cmd_multdir.format(
                format_l = destination_format.lower(),
                table = bq_table,
                bucket_path = gs_bucket_path,
                prefix_dest = gs_file_prefix,
                ext = '.' + destination_format,
                local_path = local_destination_path
            )
        print(bqc)
        rc = os.system(bqc)
        if rc != 0: exit(rc)
exit(0)

# last edit: 2020-12-03