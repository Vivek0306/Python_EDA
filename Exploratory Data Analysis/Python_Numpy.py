import numpy as np

arr1 = np.array([10, 20, 30, 40, 50], dtype='int8')
print(arr1)

'''
Numpy array builtin methods and functions
'''
print(arr1.shape) # Return the nums of rows and columns 
print(arr1.dtype) # Returns the data type of the array elements
print(arr1.itemsize) # Returns the max item size
print(arr1.ndim) # Return the dimension of the array
print(arr1.size) # Total number of elements in the array
print(arr1.nbytes) # Total size of numpy array


'''
Types of numpy array
'''
# 1D array
arr_1D = np.array([1,2,3,4,5])

# 2D array
arr_2D = np.array([[1,2,3,4,5],[6,7,8,9,10]])
print(arr_2D.shape, arr_2D.ndim)

# 3D array
arr_3D = np.array([[[1,2,3,4,5],[6,7,8,9,10]], [[1,2,3,4,5],[6,7,8,9,10]], [[1,2,3,4,5],[6,7,8,9,10]]])
print(arr_3D.shape, arr_3D.ndim)


'''
Slicing and Indexing a Numpy array
'''
# Slicing can be done using comma to seperate the rows and columns to slice
print(arr_2D[:,:])
print(arr_2D[:,0])
print(arr_2D[:,:2]) # Slicing first two columns from each row
print(arr_2D[::-1,::-1])


print(arr_3D[0,1,3]) # Slicing 3d numpy array

# Create numpy arrays using functions
arr2 = np.arange(1, 50)
print(arr2)

# Reshape a 1D array into different shape using reshape
arr3 = np.arange(1,51).reshape(10,5)
arr4 = np.arange(1,51).reshape(2,5,5)
print(arr3)
print(arr4)


# Creating a zero matrix
print(np.zeros((4,7), dtype='int32')) # Everything is be default floating numbers it can be converted to integers using dtype parameter

print(np.zeros((2,4)).astype('float16').dtype) # use "astype" to convert a prexisting array into a different data type

# Creating a ones matrix
print(np.ones((3,3)))

# Identity matrix
print(np.identity(3)) # identity matrixes are always square matrixes and needs only the number of rows are parameter

# Empty Matrix
arr5 = np.empty((3,4)) # fills with buffer values

# Fill Matrix
arr5.fill(2) # fill is sued to fill all positions of the matrix
print(arr5)

# Full
print(np.full((3,3), 3))

# Linspace - it creates an evenly spaced array based on the values specified
# linspace - (start, end, elements)
print(np.linspace(10, 100, 10))

# Logspace - it creaetes an evenly spaced array on an log scale between the specified values
print(np.logspace(0, 1, 6, base=10))



# Examples

myarr = np.full((10, 10), 1)
myarr[1:-1,1:-1].fill(0)
print(myarr)

myarr1 = np.full((10, 10), 1)
myarr1[::2,::2].fill(0)
myarr1[1::2, 1::2].fill(0)
print(myarr1)

'''
Mathematical operations on numpy array
'''
arr6 = np.array([[[1,2,3],[4, 5, 6],[7,8,9]], [[11,12,13],[14, 15, 16],[17,18,19]]])

print(arr6.sum())
# Axis = 0, adds rowise
print(arr6.sum(axis = 0))

# Axis = 1, adds columnwise
print(arr6.sum(axis = 1))


# Max returns the max value
print(arr6.max())

# Min returns the min value
print(arr6.min())

# where returns the index position of the value for condition = True
print(np.where(arr6 > 17))

'''
Numpy Statistical Methods
'''

arr7 = np.arange(1,37).reshape(6,6)
# Mean
arr7.mean()
arr7.mean(axis = 0)
arr7.mean(axis = 1)

# Standard Deviation
np.std(arr7)

# Variance
np.var(arr7)

# Reversing an array
arr8 = np.arange(50)

# Flip is used to flip the array 
print(np.flip(arr_2D))
print(np.flipud(arr_2D))
print(np.fliplr(arr_2D))


# Flatten - It converts a N-D array to 1-D array
arr9 = np.random.randint(10, 50, size = (5, 3))
print(arr9)
print(arr9.flatten())

# ravel() - It converts a N-D array to 1-D array
print(arr9.ravel())

# np.argmax() - It reutrns the positions of the maximum value along the specified axis
print(arr_3D)
print(np.argmax(arr_3D))