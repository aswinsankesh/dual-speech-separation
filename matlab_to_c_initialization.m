

%program for making matrix compatible with C 2d array

% Input matrix include your own variable instead of softMask
matrix = HardFemaleMask;

% Get the size of the matrix
[m, n] = size(matrix);

% Initialize the 2D array
array = zeros(m, n);

% Convert the matrix into a 2D array
for i = 1:m
    for j = 1:n
        array(i, j) = matrix(i, j);
    end
end

% Save the 2D array to a text file with curly brackets
fid = fopen('binMask_hello.txt', 'w');
fprintf(fid, '#define ROWS %d \n',m);
fprintf(fid, '#define COLS %d \n',n);
fprintf(fid, 'float mask[%d][%d] = ', m , n);
fprintf(fid, '{');
for i = 1:m
    fprintf(fid, '{');
    for j = 1:n
        fprintf(fid, '%d', array(i, j));
        if j < n
            fprintf(fid, ', ');
        end
    end
    fprintf(fid, '}');
    if i < m
        fprintf(fid, ',\n');
    end
end
fprintf(fid, '}');
fclose(fid);

