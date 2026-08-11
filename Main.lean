import PiNoIntegral

/-!
这个可执行入口同时充当最小审计：编译时打印主定理类型和公理依赖。
-/

#check PiNoIntegral.pi_irrational_no_integral
#print axioms PiNoIntegral.pi_irrational_no_integral

def main : IO Unit :=
  IO.println "Lean MIL pi course project compiled successfully."
