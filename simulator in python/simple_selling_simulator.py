"""
    This program is created in 2020-10-11, it calculates the amount in terms of price a seller gets
    by selling in a dynamic way.
"""

def main():
    x = float(input("Enter the amount of token you are selling:"))
    s = float(input("Enter the current supply of the token:"))
    
    #formula for calculation
    y = 2/3*((s)**(3/2)-(s-x)**(3/2))
    #update supply
    s = s-x
    z = y/x
    print("Amount in USDT you get: " +str(y))
    print("Average Solid Price " + str(z))
    print("The current supply after you sold is: "+str(s))

main()
