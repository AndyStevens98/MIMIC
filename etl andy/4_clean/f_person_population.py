from faker import Faker
import pandas as pd
import random


fake = Faker()

# This script requires an export of the person_id and gender_concept_id columns from the person_table

f_person_df = pd.read_csv('person_export.csv', usecols=['person_id', 'gender_concept_id'])
f_person_df

for i, row in f_person_df.iterrows():
    last_name = fake.last_name()

    match row['gender_concept_id']:
        case 8507:
            given1_name = fake.first_name_male()
        case 8532:
            given1_name = fake.first_name_female()
        case _:
            given1_name = fake.first_name_nonbinary()

    rand_phone_number = str(random.randint(1000000000, 9999999999))
    phone_number = '-'.join([rand_phone_number[0:3], rand_phone_number[3:6], rand_phone_number[6:]])

    f_person_df.loc[i, 'family_name'] = last_name
    f_person_df.loc[i, 'given1_name'] = given1_name
    f_person_df.loc[i, 'ssn'] = fake.ssn()
    f_person_df.loc[i, 'active'] = 1
    f_person_df.loc[i, 'contact_point1'] = f'phone:{random.choice(["home", "mobile"])}:{phone_number}'
    f_person_df.loc[i, 'contact_point2'] = f'email:{random.choice(["home", "mobile"])}:{given1_name + last_name + "@" + fake.free_email_domain()}'
    f_person_df.loc[i, 'martialstatus'] = random.choice(['U', 'D', 'M'])

f_person_df.to_csv('f_person.csv', index=False)
