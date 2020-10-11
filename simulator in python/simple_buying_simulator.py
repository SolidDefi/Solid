"""
    This program is created in 2020-10-11, it calculates the amount of token
    a buyer gets by buying in a dynamic way.
"""

def main():
    x = float(input("Enter the amount in USDT you are paying:"))
    s = float(input("Enter the current supply of the token:"))
    
    #formula for calculation
    y = (3/2*x+s**(3/2))**(2/3)-s
    #update supply
    s = s+y
    
    print("Amount of token you get: " +str(y))
    print("The current supply after you bought is: "+str(s))
main()
