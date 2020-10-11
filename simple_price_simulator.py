"""
    This program is created in 2020-10-11, it calculates the amount of token a buyer get by bying in a dynamic manner.
"""

def main():
    x = input("Enter the amount in USDT you are paying:")
    p = input("Enter the current supply of the token:")
    x = float(x)
    p = float(p)
    y = (3/2*x+p**(3/2))**(2/3)-p
    print("Amount of token you get:" +str(y))
main()
