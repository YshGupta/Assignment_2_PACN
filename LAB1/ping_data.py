import pickle
from datetime import datetime

with open('ping_data.pkl', 'rb') as file:
    loaded_data = pickle.load(file)

# Access the loaded data
Names =loaded_data['Names']
Servers = loaded_data['Servers']
Times = loaded_data['Times']
Delays = loaded_data['Delays']
Throughputs = loaded_data['Throughputs']

# dt_object = datetime.utcfromtimestamp(Times[0][0])
# print(dt_object.minute)

print(len(Delays[0]))







