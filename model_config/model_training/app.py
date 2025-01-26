#Importando bibliotecas
from flask import Flask, request, render_template
import joblib


app = Flask(__name__)

#Carregar o modelo
model = joblib.load('rf_model.pkl')

# Criando rota
@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods = ['POST'])
def predict():

    #Executando predições
    features = [float(x) for x in request.form.values()]
    features = [features]
    y_pred = model.predict(features)
    
    return render_template('index.html', prediction_text = y_pred[0])

#Executando programa
if __name__ == "__main__":
    app.run(debug = True)
