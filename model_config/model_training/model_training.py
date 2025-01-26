# Importando bibliotecas
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
import joblib
import os

os.getcwd()

# Lendo dados
df = pd.read_csv('Churn_Modelling.csv')

# Separando dados a serem usados
target_var = ['Exited']
cols_to_remove = ['RowNumber', 'CustomerId', 'Surname', 'Geography', 'Gender', 'HasCrCard', 'IsActiveMember', 'Exited']
num_feats = ['CreditScore', 'Age', 'Tenure', 'Balance', 'NumOfProducts', 'EstimatedSalary']

# Removendo colunas
y = df[target_var].values
df.drop(cols_to_remove, axis=1, inplace=True)

# Dividindo dados entre treino e teste
df_train_val, df_test, y_train_val, y_test = train_test_split(df, y.ravel(), test_size = 0.1, random_state = 42)
df_train, df_val, y_train, y_val = train_test_split(df_train_val, y_train_val, test_size = 0.12, random_state = 42)

df_train_val

# Treinando o modelo
model = RandomForestClassifier()
model.fit(df_train, y_train)

# Avaliando o acurácia
y_pred = model.predict(df_test)
acc = accuracy_score(y_test, y_pred)
print(acc)

# Exportando modelo
joblib.dump(model, 'rf_model.pkl')