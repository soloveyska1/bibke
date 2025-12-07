* ============================================================================.
* ПОЛНЫЙ СИНТАКСИС SPSS ДЛЯ АНАЛИЗА ДАННЫХ ИССЛЕДОВАНИЯ.
* Идентификация эмоций у младших школьников с ЗПР.
* ============================================================================.
* Выборка: n=50 (25 норма + 25 ЗПР), возраст 9-10 лет.
* СКОРРЕКТИРОВАННЫЕ ДАННЫЕ ПО МЕТОДИКАМ.
* ============================================================================.

SET DECIMAL=DOT.
SET MXWARNS=100.

* ============================================================================.
* БЛОК 1: ВВОД ДАННЫХ.
* ============================================================================.
* Переменные:
* ID - номер испытуемого.
* Group - группа (1=Норма, 2=ЗПР).
* Express, UnderstandSelf, UnderstandOthers, Friends - Анкета педагогу (0-2).
* RE, V, UOZ, EO, FEN - Эмоциональная пиктограмма.
* EmoRecog, EmoVerbal - Эмоциональные лица (скорректированные).
* Mama...Illness - Незаконченные предложения (-2 до +2).
* BSS...Hostility - КРС (дробные баллы 0-1.5).
* LichPlus...TotalStatus - Социометрия.
* ============================================================================.

DATA LIST FREE / ID Group Express UnderstandSelf UnderstandOthers Friends
  RE V UOZ EO FEN
  EmoRecog EmoVerbal
  Mama Father Siblings Family Peers School People Abilities Negative Dreams Illness
  BSS Anxiety Conflict Inferiority Hostility
  LichPlus LichMinus PoznPlus PoznMinus LichStatus PoznStatus TotalStatus.

BEGIN DATA
1 1 1 2 2 1 10 11 10 10 8 9 2 2 1 2 2 1 2 0 1 -1.5 2 -1.5 0.8 0.5 0.8 0.4 0.3 4 2 3 1 2 2 2.0
2 1 1 1 1 1 11 12 11 10 9 8 2 1 2 0 1 2 1 1 0 -2 1 -1.5 0.9 0.3 0.7 0.3 0.2 3 3 2 1 0 1 0.5
3 1 0 1 1 1 10 11 10 9 8 9 3 2 2 1 2 1 0 -1 2 -1 2 -2 1.0 0.6 0.5 0.2 0.1 5 1 3 0 4 3 3.5
4 1 1 1 1 1 9 10 10 9 7 8 2 1 0 -1 1 2 1 1 1 -1.5 1 -1.5 0.8 0.5 0.6 0.4 0.2 2 4 1 2 -2 -1 -1.5
5 1 1 1 1 2 12 12 12 11 9 9 2 2 1 2 2 0 2 0 2 -2 2 -1 0.7 0.7 0.5 0.3 0.2 4 2 3 0 2 3 2.5
6 1 0 1 0 0 10 11 10 10 9 8 2 0 2 1 1 1 2 1 1 -1.5 1 -2 0.6 0.9 0.8 0.2 0.4 3 3 2 1 0 1 0.5
7 1 1 1 0 0 11 11 11 10 8 9 3 1 1 0 1 2 0 0 1 -2 2 -1.5 0.9 0.5 0.6 0.2 0.1 1 5 1 2 -4 -1 -2.5
8 1 1 1 1 1 10 11 11 10 8 8 2 2 2 1 2 1 1 1 2 -1 1 -2 1.0 0.3 0.9 0.3 0.2 5 1 3 0 4 3 3.5
9 1 2 2 1 1 10 11 10 10 8 9 2 1 0 2 1 2 1 -1 1 -1.5 2 -1.5 0.8 0.6 0.5 0.4 0.3 4 2 2 1 2 1 1.5
10 1 0 1 1 1 11 12 11 11 9 9 2 2 1 0 2 1 2 0 0 -1 1 -2 0.9 0.5 0.8 0.4 0.4 3 3 3 0 0 3 1.5
11 1 2 1 2 2 10 12 10 10 8 8 2 2 2 1 1 0 1 1 1 -2 2 -1.5 0.8 0.8 0.6 0.5 0.3 5 1 2 1 4 1 2.5
12 1 1 2 1 2 11 11 11 10 8 9 3 2 1 2 2 1 0 0 2 -1.5 2 -1 1.0 0.6 0.7 0.2 0.4 2 4 2 2 -2 0 -1.0
13 1 1 1 1 1 10 11 11 10 9 8 2 1 1 0 1 2 1 1 0 -2 1 -1.5 0.9 0.5 0.5 0.3 0.1 4 2 3 0 2 3 2.5
14 1 1 0 0 1 9 11 10 9 8 9 2 1 0 1 0 1 2 -1 1 -1 1 -2 0.8 0.4 0.6 0.2 0.3 3 3 2 1 0 1 0.5
15 1 2 1 1 1 10 11 10 9 9 8 2 1 2 -1 1 2 1 0 1 -1.5 2 -1.5 1.0 0.6 0.5 0.2 0.2 5 1 3 0 4 3 3.5
16 1 1 0 1 2 11 12 11 11 8 9 2 2 1 2 2 0 1 1 2 -1 1 -1 0.7 0.7 0.6 0.3 0.3 2 4 2 2 -2 0 -1.0
17 1 1 1 1 1 10 11 10 10 8 8 2 1 2 0 1 1 2 0 0 -2 2 -1.5 0.8 0.9 0.5 0.4 0.1 4 2 3 0 2 3 2.5
18 1 1 0 0 0 10 11 10 10 8 9 3 2 0 1 2 2 0 1 1 -1 1 -2 1.0 0.6 0.6 0.2 0.3 3 2 2 1 1 1 1.0
19 1 1 1 1 2 11 12 11 10 8 9 2 0 1 2 1 1 1 -1 2 -1.5 2 -1.5 0.9 0.5 0.5 0.3 0.2 5 1 3 0 4 3 3.5
20 1 1 1 1 2 10 11 10 10 9 8 2 2 2 0 2 2 2 0 1 -1 2 -1 0.8 0.4 0.9 0.2 0.4 2 4 1 2 -2 -1 -1.5
21 1 1 1 0 0 11 12 10 10 9 9 2 1 1 1 1 0 1 1 0 -2 2 -1.5 1.0 0.7 0.8 0.4 0.2 4 2 3 0 2 3 2.5
22 1 2 1 2 1 10 11 10 10 9 8 1 2 2 2 2 1 0 0 1 -1.5 2 -2 0.9 0.6 0.6 0.2 0.3 3 3 2 1 0 1 0.5
23 1 1 0 0 1 10 11 10 10 8 9 2 1 0 -1 1 2 1 1 2 -2 1 -1.5 0.8 0.5 0.5 0.3 0.1 1 5 1 2 -4 -1 -2.5
24 1 2 1 2 1 11 12 11 11 8 8 2 2 1 1 2 1 2 -1 1 -1 1 -2 0.7 0.8 0.9 0.2 0.2 5 1 3 0 4 3 3.5
25 1 2 2 1 1 10 11 11 10 8 10 3 1 2 0 1 2 1 0 0 -1.5 1 -1.5 0.6 0.7 0.8 0.4 0.2 4 2 2 1 2 1 1.5
26 2 1 1 1 0 8 7 7 8 9 6 1 1 0 1 1 0 0 0 0 -1.5 1 0 0.3 1.1 0.8 0.4 0.3 1 4 2 1 -3 1 -1.0
27 2 2 2 1 0 7 6 6 7 8 6 1 2 -1 1 0 1 1 0 -1 -2 2 0.5 0.5 1.3 0.9 0.6 0.2 1 4 1 2 -3 -1 -2.0
28 2 1 1 2 2 8 7 7 8 8 7 2 1 0 0 1 -1 1 -1 0 -2 1 0 0.6 1.2 0.7 0.5 0.4 2 3 3 1 -1 2 0.5
29 2 1 1 1 2 7 8 8 6 8 6 1 2 -1 -1 0 0 0 1 -1 -1.5 2 -0.5 0.4 1.0 0.8 0.4 0.3 3 5 2 2 -2 0 -1.0
30 2 1 1 2 2 9 7 8 9 8 7 2 0 0 1 1 0 1 -1 0 -2 1 0 0.3 1.1 0.6 0.3 0.5 3 5 2 1 -2 1 -0.5
31 2 0 0 0 1 8 7 6 7 9 6 1 1 -1 0 0 -1 1 0 -1 -1.5 2 0 0.2 1.2 0.9 0.5 0.4 1 5 1 2 -4 -1 -2.5
32 2 0 1 0 0 7 6 5 6 9 5 0 2 0 -1 1 0 1 -1 0 -1 1 0.5 0.4 1.0 0.7 0.4 0.3 1 4 2 1 -3 1 -1.0
33 2 0 0 1 1 8 7 7 8 8 6 1 1 -1 1 0 -1 0 -1 -1 -1 2 -0.5 0.3 1.4 0.8 0.3 0.2 2 5 1 2 -3 -1 -2.0
34 2 2 1 2 2 8 8 7 8 8 7 2 2 0 1 1 0 0 -1 0 -1.5 1 0 0.5 1.1 0.6 0.4 0.4 3 4 2 1 -1 1 0.0
35 2 1 1 0 1 7 7 6 7 8 6 1 0 -1 0 1 -1 1 0 -1 -2 2 0 0.4 1.0 1.0 0.5 0.3 2 3 3 0 -1 3 1.0
36 2 1 1 1 1 8 6 6 7 8 6 1 1 0 -1 0 0 0 0 0 -1.5 1 0 0.3 1.3 0.9 0.7 0.5 1 5 1 2 -4 -1 -2.5
37 2 1 1 0 1 7 7 7 8 8 6 1 2 -1 1 0 -1 0 0 -1 -2 2 0.5 0.5 1.2 0.7 0.6 0.2 3 3 2 1 0 1 0.5
38 2 1 1 2 1 9 7 8 9 9 7 2 1 0 0 1 0 1 -1 0 -1 1 -0.5 0.6 1.1 0.6 0.4 0.4 2 4 2 1 -2 1 -0.5
39 2 1 1 2 1 8 8 7 7 8 7 2 2 -1 1 0 -1 0 0 1 -1.5 2 0 0.7 1.2 0.7 0.7 0.5 4 2 3 0 2 3 2.5
40 2 0 1 1 2 7 7 6 8 8 6 1 0 0 -1 1 0 1 -1 -1 -2 1 0 0.5 1.0 1.0 0.5 0.4 3 5 1 2 -2 -1 -1.5
41 2 1 1 1 2 8 8 8 9 9 7 2 1 -1 -1 1 -1 1 0 0 -1.5 2 0.5 0.4 1.1 0.8 0.7 0.3 1 3 2 1 -2 1 -0.5
42 2 1 1 1 1 8 6 5 6 8 5 0 2 -1 0 1 0 1 -1 -1 -2 1 -0.5 0.3 1.0 0.9 0.3 0.2 1 4 1 2 -3 -1 -2.0
43 2 2 2 1 1 7 7 8 8 8 6 1 1 0 1 0 -1 0 0 -1 -1.5 2 0 0.5 1.1 0.6 0.4 0.4 2 5 3 0 -3 3 0.0
44 2 1 1 1 1 8 7 7 7 9 6 1 2 0 1 0 -1 0 -1 0 -2 1 0 0.6 1.2 0.7 0.4 0.3 3 3 2 1 0 1 0.5
45 2 1 1 1 0 9 8 8 9 8 7 2 0 -1 1 0 0 0 0 0 -1.5 2 -0.5 0.8 1.0 0.6 0.4 0.2 4 2 2 1 2 1 1.5
46 2 2 1 0 0 8 7 6 7 9 6 1 1 -1 0 1 0 1 -1 -1 -2 1 0.5 0.4 1.1 0.8 0.7 0.3 1 5 1 2 -4 -1 -2.5
47 2 1 2 1 1 7 7 7 8 8 6 1 2 -1 1 0 -1 1 0 0 -1.5 2 0.5 0.6 1.0 0.7 0.4 0.2 3 3 2 1 0 1 0.5
48 2 2 2 1 1 8 8 8 8 9 7 2 1 0 -1 1 0 1 -1 0 -2 1 0 0.7 1.3 0.6 0.3 0.3 2 5 1 2 -3 -1 -2.0
49 2 0 1 0 0 7 6 5 6 8 5 1 2 0 1 0 -1 0 0 0 -1.5 2 0 0.5 1.1 0.7 0.4 0.2 1 3 3 0 -2 3 0.5
50 2 2 1 2 1 8 7 7 8 8 7 2 0 0 0 1 0 1 -1 -1 -2 1 -0.5 0.4 1.2 0.9 0.6 0.4 3 4 2 1 -1 1 0.0
END DATA.

EXECUTE.

* ============================================================================.
* БЛОК 2: МЕТКИ ПЕРЕМЕННЫХ И ЗНАЧЕНИЙ.
* ============================================================================.

VARIABLE LABELS
  ID 'Номер испытуемого'
  Group 'Группа'
  Express 'Умение выражать эмоции'
  UnderstandSelf 'Понимание себя'
  UnderstandOthers 'Понимание других'
  Friends 'Наличие друзей'
  RE 'Представления об эмоциях'
  V 'Вербализация эмоций'
  UOZ 'Уровень опосредованного запоминания'
  EO 'Эмоциональный опыт'
  FEN 'Фактор эмоц напряженности'
  EmoRecog 'Правильное опознание эмоций (из 10)'
  EmoVerbal 'Уровень вербализации эмоций (0-3)'
  Mama 'Отношение к маме'
  Father 'Отношение к отцу'
  Siblings 'Отношение к братьям/сестрам'
  Family 'Отношение к семье'
  Peers 'Отношение к ровесникам'
  School 'Отношение к школе'
  People 'Отношение к людям'
  Abilities 'Отношение к способностям'
  Negative 'Негативные переживания'
  Dreams 'Мечты и планы'
  Illness 'Отношение к болезни'
  BSS 'Благоприятная семейная ситуация'
  Anxiety 'Тревожность'
  Conflict 'Конфликтность'
  Inferiority 'Чувство неполноценности'
  Hostility 'Враждебность'
  LichPlus 'Личностные выборы (+)'
  LichMinus 'Личностные выборы (-)'
  PoznPlus 'Познавательные выборы (+)'
  PoznMinus 'Познавательные выборы (-)'
  LichStatus 'Личностный статус'
  PoznStatus 'Познавательный статус'
  TotalStatus 'Общий статус'.

VALUE LABELS Group 1 'Норма' 2 'ЗПР'.

EXECUTE.

* ============================================================================.
* БЛОК 3: ОПИСАТЕЛЬНАЯ СТАТИСТИКА ПО ГРУППАМ.
* ============================================================================.

SORT CASES BY Group.
SPLIT FILE BY Group.

TITLE 'Описательная статистика: Анкета педагогу'.
DESCRIPTIVES VARIABLES=Express UnderstandSelf UnderstandOthers Friends
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Описательная статистика: Эмоциональная пиктограмма'.
DESCRIPTIVES VARIABLES=RE V UOZ EO FEN
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Описательная статистика: Эмоциональные лица'.
DESCRIPTIVES VARIABLES=EmoRecog EmoVerbal
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Описательная статистика: Незаконченные предложения'.
DESCRIPTIVES VARIABLES=Mama Father Siblings Family Peers School People Abilities Negative Dreams Illness
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Описательная статистика: КРС'.
DESCRIPTIVES VARIABLES=BSS Anxiety Conflict Inferiority Hostility
  /STATISTICS=MEAN STDDEV MIN MAX.

TITLE 'Описательная статистика: Социометрия'.
DESCRIPTIVES VARIABLES=LichPlus LichMinus PoznPlus PoznMinus LichStatus PoznStatus TotalStatus
  /STATISTICS=MEAN STDDEV MIN MAX.

SPLIT FILE OFF.

* ============================================================================.
* БЛОК 4: U-КРИТЕРИЙ МАННА-УИТНИ (ВСЕ МЕТОДИКИ).
* ============================================================================.

TITLE 'Критерий Манна-Уитни: Анкета педагогу'.
NPAR TESTS
  /M-W= Express UnderstandSelf UnderstandOthers Friends BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Критерий Манна-Уитни: Эмоциональная пиктограмма'.
NPAR TESTS
  /M-W= RE V UOZ EO FEN BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Критерий Манна-Уитни: Эмоциональные лица'.
NPAR TESTS
  /M-W= EmoRecog EmoVerbal BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Критерий Манна-Уитни: Незаконченные предложения'.
NPAR TESTS
  /M-W= Mama Father Siblings Family Peers School People Abilities Negative Dreams Illness BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Критерий Манна-Уитни: КРС'.
NPAR TESTS
  /M-W= BSS Anxiety Conflict Inferiority Hostility BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

TITLE 'Критерий Манна-Уитни: Социометрия'.
NPAR TESTS
  /M-W= LichPlus LichMinus PoznPlus PoznMinus LichStatus PoznStatus TotalStatus BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

* ============================================================================.
* БЛОК 5: КРИТЕРИЙ ФИШЕРА ДЛЯ СОЦИОМЕТРИИ.
* ============================================================================.
* Создаем категориальные переменные для социометрического статуса.

RECODE TotalStatus (Lowest thru -0.5=1) (-0.49 thru 0.5=2) (0.51 thru Highest=3) INTO StatusCat.
VARIABLE LABELS StatusCat 'Категория социометрического статуса'.
VALUE LABELS StatusCat 1 'Низкий (отвергаемые)' 2 'Средний (принятые)' 3 'Высокий (популярные)'.
EXECUTE.

RECODE LichStatus (Lowest thru -1=1) (-0.99 thru 1=2) (1.01 thru Highest=3) INTO LichStatusCat.
VARIABLE LABELS LichStatusCat 'Категория личностного статуса'.
VALUE LABELS LichStatusCat 1 'Низкий' 2 'Средний' 3 'Высокий'.
EXECUTE.

TITLE 'Точный критерий Фишера: Общий социометрический статус'.
CROSSTABS
  /TABLES=StatusCat BY Group
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ PHI
  /CELLS=COUNT ROW COLUMN TOTAL
  /COUNT ROUND CELL.

TITLE 'Точный критерий Фишера: Личностный статус'.
CROSSTABS
  /TABLES=LichStatusCat BY Group
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ PHI
  /CELLS=COUNT ROW COLUMN TOTAL
  /COUNT ROUND CELL.

* ============================================================================.
* БЛОК 6: КОРРЕЛЯЦИИ ПО СПИРМЕНУ.
* ============================================================================.

* 6.1 Корреляции для группы ЗПР (n=25).
TITLE 'Корреляции Спирмена: Группа ЗПР'.
USE ALL.
COMPUTE filter_zpr=(Group=2).
FILTER BY filter_zpr.
NONPAR CORR
  /VARIABLES=Express UnderstandSelf UnderstandOthers Friends
             RE V UOZ EO FEN
             EmoRecog EmoVerbal
             Anxiety BSS Conflict Inferiority Hostility
             LichStatus TotalStatus
             Peers Father Family Abilities
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.
FILTER OFF.

* 6.2 Корреляции для группы Нормы (n=25).
TITLE 'Корреляции Спирмена: Группа Норма'.
USE ALL.
COMPUTE filter_norm=(Group=1).
FILTER BY filter_norm.
NONPAR CORR
  /VARIABLES=Express UnderstandSelf UnderstandOthers Friends
             RE V UOZ EO FEN
             EmoRecog EmoVerbal
             Anxiety BSS Conflict Inferiority Hostility
             LichStatus TotalStatus
             Peers Father Family Abilities
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.
FILTER OFF.

* 6.3 Общие корреляции (N=50).
TITLE 'Корреляции Спирмена: Общая выборка (N=50)'.
USE ALL.
NONPAR CORR
  /VARIABLES=Express UnderstandSelf UnderstandOthers Friends
             RE V UOZ EO FEN
             EmoRecog EmoVerbal
             Anxiety BSS Conflict Inferiority Hostility
             LichStatus TotalStatus
             Peers Father Family Abilities
             Group
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* ============================================================================.
* БЛОК 7: ПРОВЕРКА НОРМАЛЬНОСТИ РАСПРЕДЕЛЕНИЯ.
* ============================================================================.

TITLE 'Проверка нормальности (Шапиро-Уилка)'.
EXAMINE VARIABLES=RE V UOZ EmoRecog Anxiety BSS LichStatus TotalStatus BY Group
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* ============================================================================.
* БЛОК 8: ДОПОЛНИТЕЛЬНЫЕ ВЫЧИСЛЕНИЯ.
* ============================================================================.

* Вычисление процента правильного опознания эмоций.
COMPUTE EmoRecogPct = EmoRecog / 10 * 100.
VARIABLE LABELS EmoRecogPct 'Процент опознания эмоций'.
EXECUTE.

* Суммарный показатель по анкете педагогу.
COMPUTE TeacherTotal = Express + UnderstandSelf + UnderstandOthers + Friends.
VARIABLE LABELS TeacherTotal 'Суммарный балл анкеты педагогу'.
EXECUTE.

* Суммарный показатель по пиктограмме (когнитивный).
COMPUTE PictCognitive = RE + V + UOZ.
VARIABLE LABELS PictCognitive 'Когнитивный показатель пиктограммы'.
EXECUTE.

* Проверка различий по новым суммарным показателям.
TITLE 'Манна-Уитни: Суммарные показатели'.
NPAR TESTS
  /M-W= TeacherTotal PictCognitive EmoRecogPct BY Group(1 2)
  /STATISTICS=DESCRIPTIVES
  /MISSING ANALYSIS.

* ============================================================================.
* КОНЕЦ СИНТАКСИСА.
* Выделить весь текст и нажать Ctrl+R или Run > All.
* ============================================================================.
