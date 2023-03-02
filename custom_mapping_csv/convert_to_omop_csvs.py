import glob
import pandas as pd
import os

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

file_list = glob.glob(r"*.csv")

for file_name in file_list:
    temp_csv = pd.read_csv(file_name)
    temp_con_df = pd.DataFrame(columns=['concept_id', 'concept_name', 'domain_id', 'vocabulary_id', 'concept_class_id', 'standard_concept', 'concept_code', 'valid_start_date', 'valid_end_date', 'invalid_reason'])
    temp_cr_df = pd.DataFrame(columns=['concept_id_1', 'concept_id_2', 'relationship_id', 'valid_start_date', 'valid_end_date', 'invalid_reason'])
    temp_cr_df_reverse = pd.DataFrame(columns=['concept_id_1', 'concept_id_2', 'relationship_id', 'valid_start_date', 'valid_end_date', 'invalid_reason'])

    temp_con_df.concept_id = temp_csv.source_concept_id
    temp_con_df.concept_name = temp_csv.concept_name
    temp_con_df.domain_id = temp_csv.source_domain_id
    temp_con_df.vocabulary_id = temp_csv.source_vocabulary_id
    temp_con_df.concept_class_id = temp_csv.source_concept_class_id
    temp_con_df.standard_concept = temp_csv.standard_concept
    temp_con_df.concept_code = temp_csv.concept_code
    temp_con_df.valid_start_date = temp_csv.valid_start_date
    temp_con_df.valid_end_date = temp_csv.valid_end_date
    temp_con_df.invalid_reason = temp_csv.invalid_reason

    temp_cr_df.concept_id_1 = temp_csv.source_concept_id
    temp_cr_df.concept_id_2 = temp_csv.target_concept_id
    temp_cr_df.relationship_id = temp_csv.relationship_id
    temp_cr_df.valid_start_date = temp_csv.relationship_valid_start_date
    temp_cr_df.valid_end_date = temp_csv.relationship_end_date
    temp_cr_df.invalid_reason = temp_csv.invalid_reason_cr

    temp_cr_df_reverse.concept_id_1 = temp_csv.target_concept_id
    temp_cr_df_reverse.concept_id_2 = temp_csv.source_concept_id
    temp_cr_df_reverse.relationship_id = temp_csv.reverese_relationship_id
    temp_cr_df_reverse.valid_start_date = temp_csv.relationship_valid_start_date
    temp_cr_df_reverse.valid_end_date = temp_csv.relationship_end_date
    temp_cr_df_reverse.invalid_reason = temp_csv.invalid_reason_cr

    temp_cr_df_final = pd.concat([temp_cr_df, temp_cr_df_reverse], ignore_index=True)

    temp_con_df.to_csv(f'omoped_csvs/{file_name.split(".")[0]}_con.csv', index=False)
    temp_cr_df_final.to_csv(f'omoped_csvs/{file_name.split(".")[0]}_cr.csv', index=False)
