import pandas as pd
import numpy as np
from IPython.display import display, Markdown
from matplotlib import font_manager, rc, rcParams  # enable_korean_plt


def get_filenames_by(keyword: str, prefix="."):
    import glob
    if type(keyword) is not str:
        raise TypeError("argument 'keyword' must be str type")
    return glob.glob(prefix+"/*"+keyword+"*")


def read_excel_by(keyword: str, prefix="."):
    all_files = get_filenames_by(keyword, prefix)
    df_from_each_file = []
    for f in all_files:
        if f.endswith("xls"):
            df_from_each_file.append(pd.read_excel(f, encoding="utf8"))
        elif f.endswith("csv"):
            df_from_each_file.append(pd.read_csv(f, encoding="utf8"))
        else:
            raise ValueError("Unknown file extension: {}".format(f))
    return pd.concat(df_from_each_file, ignore_index=True, sort=True)


def show_columns_md(df: pd.DataFrame, cols=5):
    column_count = len(df.columns)
    left_count = column_count % cols
    out = "|" + "|".join([f"col{i}" for i in range(1, 6)]) + "|\n"
    out += "|" + "|".join(["--------" for i in range(1, 6)]) + "|\n"
    for i in range(0, column_count-left_count, cols):
        out += "|"+"|".join(df.columns[i:i+cols])+"|\n"
    if column_count % cols != 0:
        for i in range(column_count-left_count, column_count):
            out += "|" + df.columns[i]
        for i in range(column_count, column_count-left_count+cols):
            out += "|."
        out += "|\n"
    display(Markdown(out))


def load_markdown(filename: str):
    with open(filename, "r", encoding="utf8") as f:
        s = f.read()
    display(Markdown(s))


def remove_duplicated_member(df_member: pd.DataFrame, id_col_name="아이디", reactivate_col_name="휴면해제일"):
    id_counts = df_member[id_col_name].value_counts()
    duplicated_ids = id_counts[id_counts == 2].index
    non_duplicated_ids = id_counts[id_counts == 1].index
    df_member_tmp = df_member.copy()
    df_member_dup = df_member_tmp[df_member_tmp[id_col_name].isin(
        duplicated_ids)]
    df_member_nan = df_member_dup[~pd.isnull(
        df_member_dup[reactivate_col_name])].set_index(id_col_name)
    df_member_non_nan = df_member_dup[pd.isnull(
        df_member_dup[reactivate_col_name])].set_index(id_col_name)
    df_merged_dup_ids = df_member_nan.combine_first(
        df_member_non_nan).reset_index()
    return pd.concat([df_member_tmp[df_member_tmp[id_col_name].isin(non_duplicated_ids)], df_merged_dup_ids], sort=True)


def enable_korean_plt():
    font_name = font_manager.FontProperties(
        fname="c:/Windows/Fonts/malgun.ttf").get_name()
    rc('font', family=font_name)
    rcParams['axes.unicode_minus'] = False
