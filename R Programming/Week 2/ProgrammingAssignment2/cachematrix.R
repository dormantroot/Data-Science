## Given a Matrix, the 'cacheSolve' function calculates the inverse of the Matrix (assuming that the given Matrix is always inversable).
## The resulting value is saved in cache by utilizing the 'makeCacheMatrix' function.

## The following function does the following:
## set the value of the matrix
## get the value of the matrix
## set the inverse value of the matrix
## get the inverse value of the matrix
makeCacheMatrix <- function(x = matrix()) {
    inv = NULL
    
    set = function(m)
    {
      x <<- m
      inv <<- NULL
    }
    
    get = function() {x}
    setInverse = function(inverse) {inv <<- inverse}
    getInverse = function() {inv}
    
    list(set=set, get=get, setInverse=setInverse, getInverse=getInverse)
}


## Calculate the inverse value of the given matrix.
## Assumes that the given matrix is a square invertible matrix
cacheSolve <- function(x, ...) {      
   
   inv = x$getInverse()
   if(!is.null(inv))
   {
     message("getting cached data")
     return(inv)
   }
   
   m = x$get()   
   inv = solve(m)
   x$setInverse(inv)
   inv 
}


# create a square (10*10) matrix
sqMtx = matrix(sample.int(15, 10*10, TRUE), 10, 10)

# Cache the value of the matrix
c = makeCacheMatrix(sqMtx)

# Calculate the inverse of the matrix and cache the value
cacheSolve(c)
