
Reproducing "An Introduction to State Space Time Series Analysis" using Stan
============================================================================

Trying to reproduce the examples introduced in "An Introduction to State Space Time Series Analysis" using Stan.

Example data:
,,,,,,,,,,,,,

From http://www.ssfpack.com/CKbook.html:
    - logUKpetrolprice.txt
    - NorwayFinland.txt
    - UKdriversKSI.txt
    - UKinflation.txt
    - UKfrontrearseatKSI.txt

Models:
,,,,,,,

1. Introduction
    - fig01_01.R: Linear regression
2. The local level model
    - fig02_01.R: Deterministic level
    - fig02_03.R: Stochastic level
    - fig02_05.R: The local level model and Norwegian fatalities
3. The local linear trend model
    - fig03_01.R: Stochastic level and slope
    - fig03_04.R: Stochastic level and deterministic slope
    - fig03_05.R: The local linear trend model and Finnish fatalities
4. The local level model with seasonal
    - fig04_02.R: Deterministic level and seasonal
    - fig04_06.R: Stochastic level and seasonal
    - fig04_10.R: The local level and seasonal model and UK inflation
5. The local level model with explanatory variable
    - fig05_01.R: Deterministic level and explanatory variable
    - fig05_04.R: Stochastic level and explanatory variable
6. The local level model with intervention variable
    - fig06_01.R: Deterministic level and intervention variable
    - fig06_04.R: Stochastic level and intervention variable
7. The UK seat belt and inflation models
    - fig07_01.R: Deterministic level and seasonal
    - fig07_02.R: Stochastic level and seasonal
    - fig07_04.R: The UK inflation model
8. General treatment of univariate state space models
9. Multivariate time series analysis
10. State space and Box–Jenkins methods for time series analysis

**IMPORTANT** Some models output different results from textbook and R's `{dlm}` package.

Japanese
--------

Stan で　"状態空間時系列分析入門" を再現する

サンプルデータ:
,,,,,,,,,,,,,,,

http://www.ssfpack.com/CKbook.html から:
    - logUKpetrolprice.txt
    - NorwayFinland.txt
    - UKdriversKSI.txt
    - UKinflation.txt
    - UKfrontrearseatKSI.txt

モデル:
,,,,,,,

1. はじめに
    - fig01_01.R: `線形回帰 <https://rpubs.com/sinhrks/sstsa_01_01>`_
2. ローカル・レベル・モデル
    - fig02_01.R: `確定的レベル <https://rpubs.com/sinhrks/sstsa_02_01>`_
    - fig02_03.R: `確率的レベル <https://rpubs.com/sinhrks/sstsa_02_03>`_
    - fig02_05.R: `ローカル・レベル・モデルとノルウェイの事故 <https://rpubs.com/sinhrks/sstsa_02_05>`_
3. ローカル線形トレンド・モデル
    - fig03_01.R: `確率的レベルと確率的傾き <https://rpubs.com/sinhrks/sstsa_03_01>`_
    - fig03_04.R: `確率的レベルと確定的傾き <https://rpubs.com/sinhrks/sstsa_03_04>`_
    - fig03_05.R: `ローカル線形トレンド・モデルとフィンランドの事故 <https://rpubs.com/sinhrks/sstsa_03_05>`_
4. 季節要素のあるローカル・レベル・モデル
    - fig04_02.R: `確定的レベルと確定的季節要素 <https://rpubs.com/sinhrks/sstsa_04_02>`_
    - fig04_06.R: `確率的レベルと確率的季節要素 <https://rpubs.com/sinhrks/sstsa_04_06>`_
    - fig04_10.R: `ローカル・レベルと季節モデルと英国インフレーション <https://rpubs.com/sinhrks/sstsa_04_10>`_
5. 説明変数のあるローカル・レベル・モデル
    - fig05_01.R: `確定的レベルと(確定的)説明変数 <https://rpubs.com/sinhrks/sstsa_05_01>`_
    - fig05_04.R: `確率的レベルと(確定的)説明変数 <https://rpubs.com/sinhrks/sstsa_05_04>`_
6. 干渉変数のあるローカル・レベル・モデル
    - fig06_01.R: `確定的レベルと(確定的)干渉変数 <https://rpubs.com/sinhrks/sstsa_06_01>`_
    - fig06_04.R: `確率的レベルと(確定的)干渉変数 <https://rpubs.com/sinhrks/sstsa_06_04>`_
7. 英国シートベルト法とインフレーション・モデル
    - fig07_01.R: `確定的レベルと確定的季節要素 <https://rpubs.com/sinhrks/sstsa_07_01>`_
    - fig07_02.R: `確率的レベルと確率的季節要素 <https://rpubs.com/sinhrks/sstsa_07_02>`_
    - fig07_04.R: `英国インフレーション・モデル <https://rpubs.com/sinhrks/sstsa_07_04>`_
8. 単変量状態空間モデルの一般的な取り扱い
9. 多変量時系列分析
10. 時系列分析に対する状態空間法とボックス・ジェンキンス法

**重要** いくつかのモデルはテキスト、ならびに Rの `{dlm}` パッケージとは異なる値となっている
