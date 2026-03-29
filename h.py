import random
import string

cl=string.ascii_uppercase
sl=string.ascii_lowercase
di=string.digits
sc=string.punctuation

# all=""
# all=cl+sl+di+sc

def choice_6():
    x=input("Enter the sentense with or without space for which you want it to get converted to your password: ")
    list1=x.split(" ")
    list2=[]

    a="".join(random.sample(list1,len(list1)))
    # print(a)   #first time shuffling

    for i in a:
        list2.append(i)

    # print(list2)
    print("==> You password is: ","".join(random.sample(list2,len(list2))))  #Second time shuffling


def choice_5():
    per30=round(length_actual*(30/100))
    per20=round(length_actual*(20/100))

    for j in range(per30):  
        actual1=random.choice(cl)
        actual2=random.choice(sl)
        password_random.append(actual1)
        password_random.append(actual2)

    for h in range(per20):
        actual3=random.choice(di)
        actual4=random.choice(sc)
        password_random.append(actual3)
        password_random.append(actual4)


charpassword=""
password=[]
password_random=[]

length=input("\nEnter the length of the password you wish to generate: ")

while True:
    try:
        length_actual=int(length)
        if length_actual<8:
            print("Choosen length should be at least of 8.\n")
            length=input("Enter the length of the password you wish to get: ")
        else:
            break
    except:
        print("Please choose numbers only\n")
        length=input("Enter the length of the password you wish to get: ")
        # continue

    
    
# -----
print('''\nChoose which type of password you wish: 
         1. Capital Letters
         2. Small Letters
         3. Digits
         4. Special Characters
         5. Randomly generated among above 4
         6. Shuffling the letters given by user
         7. RESULT (If chosen in the range[1-4])\n''')
print('''--> You can any one or multiple option between(1-4) and then choose 7 to print the Password
--> Choose 5 to Generate a Strong Password
--> Choose 6 and 5 as a sole option\n\n''')


while True:
    # choice_list=choice.split()
    try:
        choice=input("Pick a choice: ")
        choice_actual=int(choice)
        if choice_actual==1:
            charpassword +=cl

        elif choice_actual==2:
            charpassword +=sl 

        elif choice_actual==3:
            charpassword +=di
        
        elif choice_actual==4:
            charpassword +=sc
        
        elif choice_actual==6:
            choice_6()
            print("\n------------------------------------------\n")
            break

        elif choice_actual==5:
            choice_5()   
            # for g in range(length):
            # password_random.append(password[g])
            print("\n==> Your password is: ","".join(password_random[:length_actual]))
            # print("chosen 5")
            print("\n------------------------------------------\n")  
            break                  

        elif choice_actual==7:
            break

        elif choice_actual>7:
            print("The chosen option is out of range, please chosse (1-7).\n")

        else:
            break

    except:
        # if choice.isalpha()==True:
        print("\nPick the valid option given above\n") 
        # choice_actual=input("Pick a choice-: ")
        # elif choice.isalpha().split() in choice_list:
        #     print("\nPick a valid option")
        # elif choice.startswith("e"):
        #     print("\nPick a valid option")
        


for i in range(length_actual):
    try:
        if choice_actual==1 or choice_actual==2 or choice_actual==3 or choice_actual==4 or choice_actual==7: 
            actual=random.choice(charpassword)
            password.append(actual)
            random.shuffle(password)
    except:
        break
    

if (choice_actual==1 or choice_actual==2 or choice_actual==3 or choice_actual==4) or (choice_actual==7):
    print("\n==> Your password is: ","".join(password))
    # print("chosen other")
    print("\n------------------------------------------\n")

# print(len(password))   #these are just to check
# print(len(password_random))

# print(password_random)

input()