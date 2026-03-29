import itertools
import string

def generate_potential_passwords():
    print("--- Password Recovery Generator ---")
    
    # Input the components
    words_input = input("Enter the possible words (comma separated, e.g., Coursera,nikhil,account): ")
    words = [w.strip() for w in words_input.split(',')]
    
    # Add case variations for each word
    extended_words = set()
    for w in words:
        extended_words.add(w.lower())
        extended_words.add(w.capitalize())
        extended_words.add(w.upper())
    
    nums_input = input("Enter the possible numbers (comma separated, e.g., 1999,2023): ")
    nums = [n.strip() for n in nums_input.split(',')]
    
    # Combine words and numbers as potential "blocks"
    all_blocks = list(extended_words) + nums
    
    # Special characters to try
    special=input("Enter the possible special characters (comma seperated, e.g., @,#,+ ....)")
    special_chars=[s.strip() for s in special.split(',')]
    # special_chars = ['@', '#', '$']
    
    print("\nGenerating combinations based on pattern: Block1 + Special1 + Block2 + Special2 + Block3")
    print("Checking matches...\n")

    count = 0
    # Generate permutations of 3 blocks
    for combo in itertools.permutations(all_blocks, 3):
        # Generate combinations of 2 special characters
        for s1 in special_chars:
            for s2 in special_chars:
                potential = f"{combo[0]}{s1}{combo[1]}{s2}{combo[2]}"
                print(potential)
                count += 1

    print(f"\nTotal potential passwords generated: {count}")

if __name__ == "__main__":
    generate_potential_passwords()
