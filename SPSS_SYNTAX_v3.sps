* ============================================================================.
* ИСПРАВЛЕННЫЙ СИНТАКСИС SPSS v3.3.
* Эмоциональная идентификация у младших школьников с ЗПР.
* ============================================================================.
* ИЗМЕНЕНИЯ v3.3:
* - Укорочены все TITLE (лимит SPSS: 60 символов)
* ИЗ v3.2:
* - СЕМАГО: все 0→1 в YEO, UD, GV (шкала 1-3)
* ИЗ v3.1:
* - BSS в норме ID6: 2→1
* - СОЦИОМЕТРИЯ переделана для разных референтных групп
* ============================================================================.

SET DECIMAL=DOT.
SET MXWARNS=100.

DATA LIST FREE / ID Group
  Express UnderstandSelf UnderstandOthers Friends
  RE V UOZ EO FEN
  AO YEO UD GV
  BSS Anxiety Conflict Inferiority Hostility
  Mama Father Siblings Family Peers School People Abilities Negative Dreams Illness
  LichPlus LichMinus PoznPlus PoznMinus LichStatus PoznStatus TotalStatus.

BEGIN DATA
1 1 1 1 2 1 10 11 10 10 8 9 2 2 2 2 0 1 0 0 2 1 2 2 1 2 0 1 -1.5 2 -1 3 2 3 1 1 2 1.5
2 1 2 1 1 1 11 12 11 10 9 9 2 3 2 3 0 0 1 0 1 2 0 1 2 1 1 0 -2 1 -0.5 3 2 2 1 1 1 1
3 1 1 1 1 1 10 11 10 9 8 8 3 2 3 3 0 1 0 0 2 2 1 2 1 0 -1 2 -1 2 -1 4 1 3 0 3 3 3
4 1 1 1 1 1 9 10 10 9 7 8 2 2 2 2 1 1 1 1 1 0 -1 1 2 1 1 1 -1.5 1 -1 3 2 2 1 1 1 1
5 1 2 2 1 2 12 12 12 11 9 10 3 3 3 2 0 1 1 0 2 1 2 2 0 2 0 2 -2 2 -0.5 3 2 3 0 1 3 2
6 1 1 1 1 1 10 11 10 10 9 8 2 2 2 1 1 1 1 0 0 2 1 1 1 2 1 1 -1.5 1 -1 3 2 2 1 1 1 1
7 1 1 1 1 1 8 9 8 8 8 6 1 1 1 1 2 2 1 1 1 1 0 1 2 0 0 1 -2 2 -1.5 1 4 1 2 -3 -1 -2
8 1 1 1 1 1 10 11 11 10 8 8 2 2 2 3 0 0 1 0 2 2 1 2 1 1 1 2 -1 1 0 4 1 3 0 3 3 3
9 1 2 2 2 1 10 11 10 10 8 9 2 2 2 2 1 1 1 1 1 0 2 1 2 1 -1 1 -1.5 2 -0.5 3 2 2 1 1 1 1
10 1 1 1 1 1 11 12 11 11 9 9 2 2 2 2 1 1 1 0 2 1 0 2 1 2 0 0 -1 1 -1 3 2 3 0 1 3 2
11 1 2 1 2 2 10 12 10 10 8 8 2 2 2 2 0 1 0 0 2 2 1 1 0 1 1 1 -2 2 -1 4 1 3 0 3 3 3
12 1 1 2 1 2 11 11 11 10 8 9 2 2 3 2 0 0 1 0 2 1 2 2 1 0 0 2 -1.5 2 -0.5 3 2 2 1 1 1 1
13 1 1 1 1 1 10 11 11 10 9 9 3 2 2 2 1 1 1 0 1 1 0 1 2 1 1 0 -2 1 -1 3 2 3 0 1 3 2
14 1 1 1 1 1 8 9 8 8 8 6 2 2 1 1 2 1 1 1 1 0 1 0 1 2 -1 1 -1 1 -1.5 2 3 2 1 -1 1 0
15 1 2 1 1 1 10 11 10 9 9 8 2 2 2 3 1 1 1 0 1 2 -1 1 2 1 0 1 -1.5 2 -1 4 1 3 0 3 3 3
16 1 1 1 1 2 11 12 11 11 8 9 2 2 2 2 0 1 1 0 2 1 2 2 0 1 1 2 -1 1 -0.5 3 2 2 1 1 1 1
17 1 1 1 1 1 10 11 10 10 8 8 3 2 2 2 1 1 0 0 1 2 0 1 1 2 0 0 -2 2 -1 3 2 3 0 1 3 2
18 1 1 1 1 1 10 11 10 10 8 8 2 2 3 2 0 1 1 0 2 0 1 2 2 0 1 1 -1 1 -1.5 3 2 2 1 1 1 1
19 1 2 1 1 1 11 12 11 10 8 9 2 2 2 2 1 1 1 0 0 1 2 1 1 1 -1 2 -1.5 2 -0.5 4 1 3 0 3 3 3
20 1 1 1 1 1 10 11 10 10 9 9 2 2 2 2 0 0 1 0 2 2 0 2 2 2 0 1 -1 2 -1 3 2 2 1 1 1 1
21 1 1 2 1 1 11 12 10 10 9 9 2 2 3 2 1 1 1 1 1 1 1 1 0 1 1 0 -2 2 -0.5 3 2 3 0 1 3 2
22 1 2 1 1 1 10 11 10 10 9 8 3 3 2 3 1 0 0 0 2 2 2 2 1 0 0 1 -1.5 2 -1 3 2 2 1 1 1 1
23 1 1 1 1 1 8 9 9 8 8 7 2 2 2 1 1 1 1 0 1 0 -1 1 2 1 1 2 -2 1 -1 1 4 1 2 -3 -1 -2
24 1 1 1 2 1 11 12 11 11 8 9 2 2 3 2 0 1 1 0 2 1 1 2 1 2 -1 1 -1 1 -0.5 4 1 3 0 3 3 3
25 1 1 2 1 1 10 11 11 10 8 9 3 2 2 3 0 1 1 0 1 2 0 1 2 1 0 0 -1.5 1 -1 3 2 2 1 1 1 1
26 2 1 1 1 0 7 7 6 7 9 5 1 1 1 1 0 2 2 1 1 0 1 1 0 0 0 -1 -1.5 1 -0.5 2 3 2 2 -1 0 -0.5
27 2 1 1 1 0 7 6 5 6 8 5 1 1 1 1 1 2 2 1 2 -1 1 0 1 1 0 -1 -2 2 -1 2 3 1 2 -1 -1 -1
28 2 1 1 1 1 8 7 6 7 8 6 1 1 1 1 1 2 1 1 1 0 0 1 -1 1 -1 0 -2 1 -0.5 2 3 2 1 -1 1 0
29 2 1 0 1 1 6 8 7 6 9 5 1 1 1 1 1 2 2 1 2 -1 -1 0 0 0 1 -1 -1.5 2 -1 2 3 2 2 -1 0 -0.5
30 2 1 1 1 1 8 7 7 8 8 6 1 2 1 1 0 2 1 1 0 0 1 1 0 1 -1 0 -2 1 -0.5 3 2 2 1 1 1 1
31 2 0 0 0 1 7 7 6 6 9 5 1 1 1 1 0 2 2 1 1 -1 0 0 -1 1 0 -1 -1.5 2 -0.5 2 3 1 2 -1 -1 -1
32 2 0 1 0 0 6 5 5 5 9 4 1 1 1 0 0 3 2 2 2 0 -1 1 0 1 -1 0 -1 1 -1 1 4 1 3 -3 -2 -2.5
33 2 0 0 1 1 7 7 6 7 8 5 1 1 1 1 0 2 1 0 1 -1 1 0 -1 0 -1 -1 -1 2 -0.5 2 3 2 2 -1 0 -0.5
34 2 2 1 1 2 10 10 9 9 8 8 2 2 2 2 2 1 1 0 2 0 1 1 0 0 -1 0 -1.5 1 -1 4 1 3 0 3 3 3
35 2 1 1 0 1 7 7 6 6 9 5 1 1 1 1 0 2 2 1 0 -1 0 1 -1 1 0 -1 -2 2 -0.5 2 3 2 2 -1 0 -0.5
36 2 1 1 1 1 7 6 5 6 8 4 1 1 1 1 0 3 2 1 1 0 -1 0 0 0 0 0 -1.5 1 -0.5 1 4 1 3 -3 -2 -2.5
37 2 1 1 1 1 8 7 7 8 8 6 1 1 1 1 1 2 1 1 2 -1 1 0 -1 0 0 -1 -2 2 -1 3 2 2 1 1 1 1
38 2 1 1 1 1 8 7 7 8 8 6 1 1 1 1 1 2 1 0 1 0 0 1 0 1 -1 0 -1 1 -0.5 2 3 2 2 -1 0 -0.5
39 2 1 1 1 1 9 10 8 9 8 8 2 2 2 2 2 1 1 0 2 -1 1 1 -1 0 0 0 -1.5 2 -1 4 2 3 1 2 2 2
40 2 0 1 1 1 7 6 5 6 9 5 1 1 1 1 0 2 2 1 0 -1 1 0 -1 0 0 0 -2 1 -0.5 2 3 2 2 -1 0 -0.5
41 2 1 1 1 1 8 8 7 8 9 6 1 2 1 1 1 2 1 1 1 -1 -1 1 -1 1 0 0 -1.5 2 -0.5 3 3 2 2 0 0 0
42 2 1 1 0 1 6 6 5 5 9 4 1 1 1 1 0 3 2 1 2 -1 0 1 0 1 -1 -1 -2 1 -1 1 4 1 3 -3 -2 -2.5
43 2 1 1 1 1 7 7 6 7 8 5 1 1 1 1 1 2 1 0 1 0 1 0 -1 0 0 -1 -1.5 2 -0.5 2 3 2 2 -1 0 -0.5
44 2 1 1 1 1 8 7 6 6 9 6 1 2 1 1 0 2 1 1 2 0 1 0 -1 0 -1 0 -2 1 -0.5 3 2 2 1 1 1 1
45 2 1 1 1 1 8 8 7 8 8 6 1 1 1 1 1 2 1 0 0 0 1 1 0 1 -1 0 -1.5 2 -1 3 2 2 1 1 1 1
46 2 1 1 1 0 6 6 6 6 9 4 1 1 1 0 0 2 2 1 1 -1 0 1 0 1 -1 -1 -2 1 -0.5 1 4 1 3 -3 -2 -2.5
47 2 2 1 1 1 7 7 7 7 8 5 1 1 1 1 1 2 1 0 2 -1 1 0 -1 1 0 0 -1.5 2 -1 3 2 2 1 1 1 1
48 2 0 1 0 1 8 8 7 7 9 6 1 1 1 1 1 2 1 0 1 0 -1 1 0 1 -1 0 -2 1 -0.5 2 3 1 2 -1 -1 -1
49 2 1 0 1 0 7 6 6 6 8 5 1 1 1 1 0 2 2 1 2 0 1 0 -1 0 0 0 -1.5 2 -0.5 2 3 2 1 -1 1 0
50 2 1 1 1 1 9 10 8 9 8 7 2 2 2 2 2 1 1 0 0 0 0 1 0 1 -1 -1 -2 1 -1 4 2 3 1 2 2 2
END DATA.

EXECUTE.

* ============================================================================.
* МЕТКИ ПЕРЕМЕННЫХ.
* ============================================================================.

VARIABLE LABELS
  ID 'Номер испытуемого'
  Group 'Группа (1=Норма, 2=ЗПР)'
  Express 'Анкета: Умение выражать эмоции (0-2)'
  UnderstandSelf 'Анкета: Понимание себя (0-2)'
  UnderstandOthers 'Анкета: Понимание других (0-2)'
  Friends 'Анкета: Наличие друзей (0-2)'
  RE 'Пиктограмма: Представления об эмоциях (0-12)'
  V 'Пиктограмма: Вербализация (0-12)'
  UOZ 'Пиктограмма: Уровень опосред. запоминания (0-12)'
  EO 'Пиктограмма: Эмоциональный опыт (0-12)'
  FEN 'Пиктограмма: Фактор эмоц. напряженности (0-12)'
  AO 'Семаго: Адекватность опознания (0-10)'
  YEO 'Семаго: Яркость эмоц. отклика (0-3)'
  UD 'Семаго: Уровень дифференциации (0-3)'
  GV 'Семаго: Глубина вербализации (0-3)'
  BSS 'КРС: Благоприятная семейная ситуация (0-3)'
  Anxiety 'КРС: Тревожность (0-3)'
  Conflict 'КРС: Конфликтность (0-3)'
  Inferiority 'КРС: Чувство неполноценности (0-3)'
  Hostility 'КРС: Враждебность (0-3)'
  Mama 'Предложения: Отношение к маме (-2 до +2)'
  Father 'Предложения: Отношение к отцу (-2 до +2)'
  Siblings 'Предложения: Отношение к братьям/сестрам (-2 до +2)'
  Family 'Предложения: Отношение к семье (-2 до +2)'
  Peers 'Предложения: Отношение к сверстникам (-2 до +2)'
  School 'Предложения: Отношение к школе (-2 до +2)'
  People 'Предложения: Отношение к людям (-2 до +2)'
  Abilities 'Предложения: Отношение к способностям (-2 до +2)'
  Negative 'Предложения: Негативные переживания (-2 до +2)'
  Dreams 'Предложения: Мечты и планы (-2 до +2)'
  Illness 'Предложения: Отношение к болезни (-2 до +2)'
  LichPlus 'Социометрия: Личностные выборы (+)'
  LichMinus 'Социометрия: Личностные выборы (-)'
  PoznPlus 'Социометрия: Познавательные выборы (+)'
  PoznMinus 'Социометрия: Познавательные выборы (-)'
  LichStatus 'Социометрия: Личностный статус'
  PoznStatus 'Социометрия: Познавательный статус'
  TotalStatus 'Социометрия: Общий статус'.

VALUE LABELS Group 1 'Норма' 2 'ЗПР'.

EXECUTE.

* ============================================================================.
* УРОВНИ ПО СЕМАГО (качественная интерпретация).
* ============================================================================.

* АО: адекватность опознания.
RECODE AO (8 thru 10=3) (5 thru 7=2) (0 thru 4=1) INTO AO_Level.
VARIABLE LABELS AO_Level 'Семаго: Уровень АО'.
VALUE LABELS AO_Level 1 'Низкий (0-4)' 2 'Средний (5-7)' 3 'Высокий (8-10)'.

* ЯЭО: яркость эмоционального отклика.
RECODE YEO (3=3) (2=2) (0 thru 1=1) INTO YEO_Level.
VARIABLE LABELS YEO_Level 'Семаго: Уровень ЯЭО'.
VALUE LABELS YEO_Level 1 'Низкий (0-1)' 2 'Средний (2)' 3 'Высокий (3)'.

* УД: уровень дифференциации.
RECODE UD (3=3) (2=2) (0 thru 1=1) INTO UD_Level.
VARIABLE LABELS UD_Level 'Семаго: Уровень УД'.
VALUE LABELS UD_Level 1 'Низкий (0-1)' 2 'Средний (2)' 3 'Высокий (3)'.

* ГВ: глубина вербализации.
RECODE GV (3=3) (2=2) (0 thru 1=1) INTO GV_Level.
VARIABLE LABELS GV_Level 'Семаго: Уровень ГВ'.
VALUE LABELS GV_Level 1 'Низкий (0-1)' 2 'Средний (2)' 3 'Высокий (3)'.

EXECUTE.

* ============================================================================.
* ОПИСАТЕЛЬНАЯ СТАТИСТИКА ПО ГРУППАМ.
* ============================================================================.

SORT CASES BY Group.
SPLIT FILE BY Group.

TITLE 'Статистика: Анкета'.
DESCRIPTIVES VARIABLES=Express UnderstandSelf UnderstandOthers Friends
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Статистика: Пиктограмма'.
DESCRIPTIVES VARIABLES=RE V UOZ EO FEN
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Статистика: Семаго'.
DESCRIPTIVES VARIABLES=AO YEO UD GV
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Статистика: КРС'.
DESCRIPTIVES VARIABLES=BSS Anxiety Conflict Inferiority Hostility
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Статистика: Предложения'.
DESCRIPTIVES VARIABLES=Mama Father Siblings Family Peers School People Abilities Negative Dreams Illness
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Статистика: Социометрия'.
DESCRIPTIVES VARIABLES=LichPlus LichMinus PoznPlus PoznMinus LichStatus PoznStatus TotalStatus
  /STATISTICS=MEAN STDDEV MIN MAX.

SPLIT FILE OFF.

* ============================================================================.
* РАСПРЕДЕЛЕНИЕ УРОВНЕЙ ПО СЕМАГО.
* ============================================================================.

TITLE 'Уровни Семаго: АО'.
CROSSTABS
  /TABLES=AO_Level BY Group
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW COLUMN TOTAL.

TITLE 'Уровни Семаго: ЯЭО, УД, ГВ'.
CROSSTABS
  /TABLES=YEO_Level UD_Level GV_Level BY Group
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW COLUMN TOTAL.

* ============================================================================.
* U-КРИТЕРИЙ МАННА-УИТНИ.
* ============================================================================.

TITLE 'Манна-Уитни: Анкета'.
NPAR TESTS
  /M-W= Express UnderstandSelf UnderstandOthers Friends BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Манна-Уитни: Пиктограмма'.
NPAR TESTS
  /M-W= RE V UOZ EO FEN BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Манна-Уитни: Семаго'.
NPAR TESTS
  /M-W= AO YEO UD GV BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Манна-Уитни: КРС'.
NPAR TESTS
  /M-W= BSS Anxiety Conflict Inferiority Hostility BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Манна-Уитни: Предложения'.
NPAR TESTS
  /M-W= Mama Father Siblings Family Peers School People Abilities Negative Dreams Illness BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Манна-Уитни: Социометрия'.
NPAR TESTS
  /M-W= LichPlus LichMinus PoznPlus PoznMinus LichStatus PoznStatus TotalStatus BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

* ============================================================================.
* КРИТЕРИЙ ФИШЕРА ДЛЯ СОЦИОМЕТРИИ.
* ============================================================================.

RECODE TotalStatus (Lowest thru -0.5=1) (-0.49 thru 0.5=2) (0.51 thru Highest=3) INTO StatusCat.
VARIABLE LABELS StatusCat 'Категория социометрического статуса'.
VALUE LABELS StatusCat 1 'Низкий (отвергаемые)' 2 'Средний (принятые)' 3 'Высокий (популярные)'.
EXECUTE.

TITLE 'Хи-квадрат: Соц. статус'.
CROSSTABS
  /TABLES=StatusCat BY Group
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ PHI
  /CELLS=COUNT ROW COLUMN TOTAL
  /COUNT ROUND CELL.

* ============================================================================.
* КОРРЕЛЯЦИИ ПО СПИРМЕНУ.
* ============================================================================.

* Корреляции для группы ЗПР.
TITLE 'Спирмен: ЗПР'.
USE ALL.
COMPUTE filter_zpr=(Group=2).
FILTER BY filter_zpr.
NONPAR CORR
  /VARIABLES=Express UnderstandSelf UnderstandOthers Friends
             RE V UOZ EO FEN
             AO YEO UD GV
             BSS Anxiety Conflict Inferiority Hostility
             LichStatus TotalStatus
             Mama Father Family Peers Abilities
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.
FILTER OFF.

* Корреляции для группы Нормы.
TITLE 'Спирмен: Норма'.
USE ALL.
COMPUTE filter_norm=(Group=1).
FILTER BY filter_norm.
NONPAR CORR
  /VARIABLES=Express UnderstandSelf UnderstandOthers Friends
             RE V UOZ EO FEN
             AO YEO UD GV
             BSS Anxiety Conflict Inferiority Hostility
             LichStatus TotalStatus
             Mama Father Family Peers Abilities
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.
FILTER OFF.

* Общие корреляции.
TITLE 'Спирмен: Общая (N=50)'.
USE ALL.
NONPAR CORR
  /VARIABLES=Express UnderstandSelf UnderstandOthers Friends
             RE V UOZ EO FEN
             AO YEO UD GV
             BSS Anxiety Conflict Inferiority Hostility
             LichStatus TotalStatus
             Mama Father Family Peers Abilities
             Group
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* ============================================================================.
* ПРОВЕРКА НОРМАЛЬНОСТИ.
* ============================================================================.

TITLE 'Шапиро-Уилка: Нормальность'.
EXAMINE VARIABLES=RE V UOZ AO BSS Anxiety LichStatus TotalStatus BY Group
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* ============================================================================.
* КОНЕЦ СИНТАКСИСА.
* ============================================================================.
