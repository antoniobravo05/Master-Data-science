#Clase Estadística Bayesiana. (María Hernandez Rubio)
#_________________________________________________________________________

#Estimador ML.
# En estadística, la estimación por máxima similitud 
# (conocida también como EMV y, en ocasiones, MLE por sus siglas en inglés) es un método habitual para ajustar un modelo y estimar sus parámetros.
# 
# Estimar por maxima verosimilitud es encontrar cual es el parámetro que maximiza. Cual es el parámetro con probabilidad mas alta que genera nuestros datos.
# (ver apuntes y mirar un poco referencias).
# 
# -PROBABILITY REVIEW.
# X:variable aleatoria.
# P(X=valor) es la probabilidad de que X tome un cierto valor dentro de unos valores determinados.
# p(x) representa la distribucion de la variable, representa a cada valor del dominio una probabilidad y siempre tiene que estar entre 0 y 1 y la suma de todas las prob. debe ser 1
# 
# Para variables continuas, X (v.a) tiene una funcion densidad de probabilidad f(x), cumpliendo que f(x)>0 y cuya integral entre inf y -inf es =1.
# Cuando X es una gaussiana está definida para todo R. En cambio cunando tenemos que X es una uniforme U(0,1) no.
# 
# Podemos tener no una variable, sino mas. X e Y. En este caso pasariamos a tener una pdf f(x,y).
# En este caso se puede MARGINALIZAR (se puede obtener la f(X) y f(Y) separadamente). Ver transparencias.
# 
# Probabilidad condicionada, ver transparencias.
# 
# REGLA DE BAYES.
# Si queremos calcular como cambia lo que se de X cuando se Y, puedo mirar como cambia Y cuando se X, multiplicando por la prob de x y dividiendo por la prob de y.
# 
# INDEPENDENCIA.
# X e Y son independientes si condicionar en Y no me aporta ninguna información extra, y viceversa.
# X e Y son independientes si p(x,y)=p(x)p(y)
# SI X e Y son independientes se puede probar que p(x|y)=p(x)
# Ser independientes no significa que no esten relacionadas, pueden estarlo.
# 
# TODO ESTO ES PARTE DE LO QUE SE LLAMA RAZONAMIENTO PROBABILISTICO O BAYESIANO.
# 
# NAÏVE BAYES
# Es un clasificador que parte de que las features (x_i) son independientes. Esto nos permitirá que podamos multiplicar.
# Nosotro queremos decidir a que clase pertenece. 

# Ver ejercicio de R de naive bayes.

# Bayesian vs Frequentist. Continuous prior. Conjugate prior.



