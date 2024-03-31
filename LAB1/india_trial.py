alphas = [ 0.95 , 0.45 , 0.005]
max_itrs = 300
tolerance = 1e-6

C= 1/4
p = 0.8
row = 0

max_alpha_itrs = 100
fig , axs  = plt.subplots(nrows = 3 , ncols = 2 , figsize = (20,15))

for alpha in alphas:

  x = np.random.rand(2)
  print(x)
  x_wo = x
  x_wb = x

  path = [x]
  itr = 0


# without backtracking
  for _ in range(max_itrs):
    itr += 1
    x_prev = x_wo
    grad = gradient(well_conditioned_function , x_wo , 1e-6)
    x_wo = x_wo - np.dot(alpha , grad)

    path.append(x_wo)
    diff = np.linalg.norm(x_wo  - x_prev)
    if diff <= tolerance:
      break

  plot_contour(axs[row,0] , well_conditioned_function , X1 , Y1)
  path = np.array(path)
  axs[row,0].plot(path.T[0] , path.T[1] ,  color = 'darkred' )
  axs[row,0].scatter(path.T[0] , path.T[1] , label = f"{alpha} , {itr} iterations",  color = 'darkred' , s = 40)
  axs[row, 0].legend(fontsize = 25)

  itr = 0
  path = [x_wb]


# with backtracking
  for _ in range(max_itrs):
    itr +=1
    alpha = 1
    for j in range( max_alpha_itrs):
      grad = gradient(well_conditioned_function , x_wb , 1e-6)
      dk = np.dot(grad ,-1)
      x_new = x_wb + np.dot( alpha , dk)
      f_xnew = well_conditioned_function(x_new[0] , x_new[1])
      fx = well_conditioned_function(x_wb[0] , x_wb[1])

      if (f_xnew <= ( fx + C*alpha*np.dot(dk , grad))):
        break
      else:
        alpha *= p

    x_prev = x_wb
    x_wb = x_wb +  np.dot( alpha , dk)
    path.append(x_wb)
    error_vec = x_wb - x_prev
    tolerance = np.linalg.norm(error_vec)
    if tolerance <= 1e-6:
      break

  plot_contour(axs[row,1] , well_conditioned_function , X1 , Y1)
  path = np.array(path)
  axs[row,1].plot(path.T[0] , path.T[1] ,  color = 'darkred' )

  axs[row,1].scatter(path.T[0] , path.T[1] , label = f"{itr} iterations with backtracking", color = 'darkred' , s = 40)
  axs[row,1].legend(fontsize = 25)

  row += 1
plt.tight_layout()
