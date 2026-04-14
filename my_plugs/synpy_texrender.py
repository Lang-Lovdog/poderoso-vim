import sys
import sympy
from sympy.parsing.latex import parse_latex
from sympy import pretty

def main():
    if len(sys.argv) < 2:
        return

    latex_input = sys.argv[1]

    try:
        # Keep it strictly as written
        with sympy.evaluate(False):
            expr = parse_latex(latex_input, backend='lark')

        # Render with Unicode
        print(pretty(expr, use_unicode=True))
    except Exception as e:
        # Silently fail or provide a clean error for the floating window
        print(f"SymPy Error: {str(e)[:50]}...")

if __name__ == "__main__":
    main()
