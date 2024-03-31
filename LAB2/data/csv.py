# Function to parse each line and split into 5 columns
def parse_line(line):
    parts = line.split(" | ")
    columns = [part.strip() for part in parts]
    return columns

# Function to read input file and write CSV
def convert_to_csv(input_file, output_file):
    with open(input_file, 'r') as file:
        lines = file.readlines()
    
    with open(output_file, 'w') as csvfile:
        for line in lines:
            if line.strip():  # Skip empty lines
                data = parse_line(line)
                csvfile.write(','.join(data) + '\n')

# Input and Output filenames
input_file = 'data.txt'
output_file = 'data.csv'

# Convert to CSV
convert_to_csv(input_file, output_file)

