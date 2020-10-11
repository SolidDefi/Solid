def main():
    x = input("Enter the amount in USDT you are paying:")
    p = input("Enter the currply supply of the token:")
    x = float(x)
    p = float(p)
    y = (3/2*x+p**(3/2))**(2/3)-p
    print(y)
main()
