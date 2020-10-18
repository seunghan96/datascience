import numpy as np
import requests
from bs4 import BeautifulSoup
from selenium import webdriver

def main():
    driver = webdriver.Chrome(r'C:\Users\samsung\Desktop\chromedriver_win32\chromedriver.exe')
    driver.implicitly_wait(3)
    driver.get("https://yscec.yonsei.ac.kr/")
    driver.find_element_by_name('username').send_keys('2020324009')
    driver.find_element_by_name('password').send_keys('!mom5459862')
    driver.find_element_by_xpath('//*[@id="loginbtn"]').click()
    driver.implicitly_wait(3)
    driver.get('https://yscec.yonsei.ac.kr/mod/commons/report/index.php?id=172121')
    html = driver.page_source
    soup = BeautifulSoup(html, 'html.parser')

    body = soup.select('tbody')[0]
    percent=body.find_all('td',class_="cell c7 lastcol")
    students=body.find_all('td',class_="cell c1")
    percents = [float(i.get_text()[:-1]) for i in percent]
    bad_student_idx = np.where(np.array(percents)<80)
    student_ids = [id.get_text() for id in students_id]
    bad_student_ids = [student_ids[i] for i in bad_student_idx[0]]
    
    page_lists=[]
    dictionary =dict()
    for i in range(3):
        page_lists.append('https://yscec.yonsei.ac.kr/blocks/jino_course_current/userindex.php?contextid=3336658&roleid=0&id=172121&perpage=20&accesssince=0&search&spage='+str(i))
    
    for page in page_lists:
        driver.get(page)
        html2 = driver.page_source
        soup2 = BeautifulSoup(html2, 'html.parser')
        body2 = soup2.select('tbody')[1]
        emails=[i.get_text() for i in body2.find_all('td',class_="cell c5")]
        ids=[i.get_text() for i in  body2.find_all('td',class_="cell c3")]
        dictionary.update(dict(zip(ids,emails)))
    
    BAD = [dictionary.get(bad) for bad in bad_student_ids]
    print(BAD)
    
if __name__=='__main__':
    main()
    