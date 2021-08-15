
%[tracks, newTrack_num, tracksRemoved_num] = hungarianAlgorithm(measurements, existingTracks)

%TODO:
%RESOLVE RECTANGULAR PROBLEMS, M MATRIX IS RECTANGULAR ()THERE ARE MORE MEASUREMENTS THAN TRACKS OR VICEVERSA


%hungarian algorithm
%rows-> measurements
%columns-> existing tracks
%not two measurements can be assigned to the same track

%measurements.range
%measurements.azimuth
%measurements.elevation
%measurements.velocity

%Initialize cost matrix
%n =size(existingTracks)
%M = zeros(n)
n=3;
%populate cost matrix
M=[40 60 15; 25 30 45; 55 30 25];

%step 1: row reduction: find minimum of each row
M_rowReduced = M;
for i = 1:n  %go through the rows
    minValueRow = min(M(i,:)); %minimum of that row
    for j = 1:n %go though the columns
        M_rowReduced(i,j) = M_rowReduced(i,j) - minValueRow ; 
    end
end

%step 2: column reduction: find minimum of each column
M_reduced = zeros(n);
for ii = 1:n  %go through the columns
    minValueColumn = min(M_rowReduced(:, ii)); %minimum of that column
    for jj = 1:n %go though the rows
        M_reduced(jj,ii) = M_rowReduced(jj,ii) - minValueColumn; 
    end
end
%step3: count lines to cover all zeros
zeros_location = (M_reduced==0);
zeros_elements = find(zeros_location);
zeros_num = size(zeros_elements, 1);
zeros_matrix = zeros(2, zeros_num); % fila 1: fila del cero, fila 2: columna del cero, hay tantas columnas como ceros haya en la matriz
for k =1:zeros_num
    column_index = mod(zeros_elements(k),n);
    if (column_index == 0)
        column_index = n;
    end
    if (zeros_elements(k) <= n)
        zeros_matrix(2,k) = 1; %columna
        zeros_matrix(1,k) = zeros_elements(k); %fila
    elseif(zeros_elements(k) <= 2*n)
        zeros_matrix(2,k) = 2; %columna
        zeros_matrix(1,k) = column_index; %fila
    elseif(zeros_elements(k) <= 3*n)
         zeros_matrix(2,k) = 3; %columna
        zeros_matrix(1,k) = column_index; %fila
    elseif(zeros_elements(k) <= 4*n)
         zeros_matrix(2,k) = 4; %columna
        zeros_matrix(1,k) = column_index; %fila
    elseif(zeros_elements(k) <= 5*n)
         zeros_matrix(2,k) = 5; %columna
        zeros_matrix(1,k) = column_index; %fila
    else
           
    end
end
lines_needed = n; % remove this
%step 4 shift zeros

if (lines_needed == n)
    solutions_num = 1; %unique solution
    % do nothing
elseif (lines_needed < n)
    solutions_num = 2; % two or more 
    %shift zeros
    %to do
end

%step 5: lines to cover zeros = n
%choose zeros ensuring that each row and column only contains one chosen zero
rows = zeros_matrix(1,:);
columns = zeros_matrix(2,:);

[firstmoderows, f1row] = mode(rows);
rowsWOFirstMode = rows(find(rows ~= firstmoderows));
[secondmoderows, f2row] = mode(rowsWOFirstMode);
rowsWOSecondMode = rowsWOFirstMode(find(rowsWOFirstMode ~= secondmoderows));
[thirdmoderows, f3row] = mode(rowsWOFirstMode); 



%select zeros per row
rows_dummy = zeros_matrix(1,:);
f = 2;
while f > 1
    [currentMode, f] = mode(rows_dummy);
    if (f > 1)
        rows_dummy = rows_dummy(find(rows_dummy ~= currentMode));
    end
end
rowsWOMode = rows_dummy;
selectedZeros = zeros(2,n); %2-> row and column, n-> number of zeros selected
for kk=1:size(rowsWOMode,2)
 index = find(zeros_matrix(1,:)== rowsWOMode(kk));
 selectedZeros(1, kk) = zeros_matrix(1, index);
 selectedZeros(2, kk) = zeros_matrix(2, index);
end

%select zeros per column
columns_dummy = zeros_matrix(2,:);
f = 2;
while f > 1
    [currentMode_column, f] = mode(columns_dummy);
    if (f > 1)
        columns_dummy = columns_dummy(find(columns_dummy ~= currentMode_column));
    end
end
columnsWOMode = columns_dummy;
for ij=1:size(columnsWOMode,2)
 index = find(zeros_matrix(2,:)== columnsWOMode(ij));
 selectedZeros(1, kk + ij) = zeros_matrix(1, index);
 selectedZeros(2, kk + ij) = zeros_matrix(2, index);
end

if (ij+ kk == n)
    %do nothing, the n zeros has already been selected
else %we need to select another zero(s)
    full = [1:n]; 
    sample_rows = selectedZeros(1,:);
    idx = ismember(full, sample_rows);
    selectedZeros(1, n) = full(~idx);
    
    sample_columns = selectedZeros(2,:);
    idx = ismember(full, sample_columns);
    selectedZeros(2, n) = full(~idx);
end

%display, debug
M
M_reduced
selectedZeros