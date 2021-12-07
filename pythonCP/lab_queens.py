from docplex.cp.model import CpoModel

n = 8
R = range(n)

mdl = CpoModel(name='queens')
q = mdl.integer_var_list(n, 1, n, "queens")

# write a function that states the queens constraints and returns all the solutions
# as an array of solutions (i.e., an assignment to the q variables

def find_all_solutions(q):
  for i in R: 
    for j in range(i+1,n):
      mdl.add(q[i]!=q[j])
      mdl.add(q[i]+i != q[j]+j)
      mdl.add(q[i]-i != q[j]-j)
  
  slist = []
  Solutions =  mdl.start_search()
  for sol in Solutions:
    list = []
    for r in R:
      list.append(sol[q[r]])
    slist.append(list)
  return slist

sols = find_all_solutions(q)
for s in sols:
    print(*s)
