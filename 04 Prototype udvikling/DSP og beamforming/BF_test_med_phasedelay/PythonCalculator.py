import glob
import statistics
import re
import os

# Kindly provided by Gemini


def to_engineering_notation(number, precision=2):
    """
    Converts a number into a string formatted in strict engineering notation
    (exponent is a multiple of 3).

    :param number: The float number to convert.
    :param precision: The number of digits after the decimal point (YY).
    :return: A string in the format XXX.YYeZ.
    """
    if number == 0:
        # Handle zero case
        return f"0.{'0' * precision}e+00"

    # Determine the exponent (base 10 logarithm)
    x = number
    sign = ''
    if x < 0:
        x = -x
        sign = '-'

    # Get the base 10 exponent
    exponent = 0
    if x > 0:
        exponent = int(math.floor(math.log10(x)))

    # Adjust exponent to be a multiple of 3
    eng_exponent = exponent - (exponent % 3)

    # Calculate the engineering coefficient (the mantissa part)
    coefficient = x / (10**eng_exponent)

    # Format the coefficient: total width 3 (XXX) + precision (YY) + 1 for decimal point
    # Note: Python's format specifier doesn't directly allow for a variable
    # number of digits before the decimal, but by adjusting the coefficient
    # to be between 1 and 1000, we ensure the 'XXX' part.
    format_str = f"{{:.{precision}f}}"
    coefficient_str = format_str.format(coefficient)

    # Format the exponent
    # e.g., +03, -06
    exponent_str = "{:+}0{}".format(eng_exponent // 3, abs(eng_exponent) % 3)
    exponent_str = f"{eng_exponent:+03d}"  # Ensures +/- and at least two digits, e.g., +03 or -06

    return f"{sign}{coefficient_str}e{exponent_str}"


def calculate_stats_from_files(folder_path="."):
    """
    Reads data from files named 'BF_results_NUMBERdeg.txt' in the specified folder,
    calculates the mean and the plus/minus deviation, and prints the results
    using strict engineering notation.
    """
    # ... (File finding and regex part remains the same)
    search_pattern = os.path.join(folder_path, 'BF_results_*deg.txt')
    file_list = glob.glob(search_pattern)
    degree_regex = re.compile(r'BF_results_(.+?)deg\.txt')

    if not file_list:
        print(f"No files matching '{search_pattern}' found in the folder.")
        return

    # To use log10 and floor in to_engineering_notation
    global math
    import math

    for file_path in file_list:
        filename = os.path.basename(file_path)
        match = degree_regex.search(filename)

        if match:
            degree_number = match.group(1)
        else:
            print(f"Could not extract degree number from: {filename}. Skipping.")
            continue

        data_points = []

        try:
            with open(file_path, 'r') as f:
                for line in f:
                    try:
                        data_points.append(float(line.strip()))
                    except ValueError:
                        continue  # Skip non-numeric lines

            if not data_points:
                continue

            # Calculate the statistics
            mean_value = statistics.mean(data_points)
            max_value = max(data_points)
            min_value = min(data_points)
            pm_deviation = (max_value - min_value) / 2.0

            # 6. Format and Print the result using engineering notation
            mean_eng = to_engineering_notation(mean_value, precision=2)
            pm_eng = to_engineering_notation(pm_deviation, precision=2)

            # The output format is: Degree NUMBER: mean, pm
            print(f"Degree {degree_number}: {mean_eng}, {pm_eng}")

        except FileNotFoundError:
            print(f"Error: File not found at {file_path}")
        except Exception as e:
            print(f"An unexpected error occurred while processing {filename}: {e}")


# --- Execution ---
# Call the function, using the current directory ('.') as the default folder
# If your files are in a different folder, change '.' to the actual path, e.g., 'data_files/'
calculate_stats_from_files(folder_path=".\\negative Grader")
calculate_stats_from_files(folder_path=".\\PositiveGrader")
