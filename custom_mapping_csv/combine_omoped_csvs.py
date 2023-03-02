import glob
import os
import pandas as pd

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

con_file_list = glob.glob(r'omoped_csvs/*_con.csv')
cr_file_list = glob.glob(r'omoped_csvs/*_cr.csv')

combined_con_csv = pd.concat([pd.read_csv(f) for f in con_file_list])
combined_con_csv.to_csv( "omoped_csvs/combined_con.csv", index=False)

combined_cr_csv = pd.concat([pd.read_csv(f) for f in cr_file_list])
combined_cr_csv.to_csv( "omoped_csvs/combined_cr.csv", index=False)