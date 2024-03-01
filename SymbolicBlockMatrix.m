classdef SymbolicBlockMatrix
    % Cell array contains expressions of noncommutative variables.
    % Cell is treated as one block.
    %
    % IMPROVEMENT IDEA.
    % (optimize time and numerical accuracy by multiplying with Matlab built-in function):
    % do not use cell arrays. Instead, only store
    % indices of partitioning into blocks (and perform matrix
    % multiplication with the usual * operator). 
    % Cell arrays will be then used only for printing purposes.

    properties
        C % underlying cell array (2D)
    end

    methods
        % Constructor
        function obj = SymbolicBlockMatrix(C)
            % Construct an instance of this class
            if isa(C, "cell")
                obj.C = C;
            else
                error("Wrong input type: should be 'cell'.")
            end

        end


        % Overloading operators
        function result = mtimes(obj1, obj2)
            %METHOD1 Block matrix multiplication.
            %   Just a straightforward for loop
            %
            % get dimensions
            m = size(obj1.C, 1);
            n = size(obj1.C, 2);
            l = size(obj2.C, 2);
            
            % validate dimensions
            assert(n==size(obj2.C,1) ...
                , "wrong dimensions of multiplied BlockMatrix objects")
            
            % do multiplication
            result_c = cell(m,l); % create output cell array
            for i=1:m
                for j=1:l
                    result_c{i,j} = 0;
                    for t=1:n
                        result_c{i,j} = result_c{i,j} + ...
                        obj1.C{i,t} * obj2.C{t,j};
                    end
                end
            end
        result = SymbolicBlockMatrix(result_c);
        end

        function obj = ctranspose(obj)
            obj_orig_copy = obj; % new object is created (deep copy)
            nrow = obj.n_blkrow();
            ncol = obj.n_blkcol();
            obj.C = cell(ncol, nrow); % allocate a transposed shape
            for i=1:ncol
                for j=1:nrow
                    obj.C{i, j} = obj_orig_copy.C{j,i}';
                end
            end
        end
        
        function [result] = eq(obj1, obj2)
            result = (obj1.C == obj2.C); % parentheses are for readability
        end
% To be implemented (maybe, because maybe cell2mat should only return numerical-valued matrix)        
%         function result = cell2mat(obj)
%             result = cell2mat(obj.C);
%         end
        
        % todo to improve, for clarity of display
        function [] = disp(obj)
              disp(obj.C) % for now the function does exactly the same
%             disp(obj.as_array());
        end
        
        function [result] = isempty(obj)
            result = isempty(obj.C);
        end


%         function [result] = as_array(obj)
%             % creates array of blocks of SymbolicBlockMatrix
%             %input validation
%             assert(~isempty(obj), "Empty SymbolicBlockMatrix not allowed.")
%             % do type conversion
%             result = [obj.C{1,1}];
%             for i=1:obj.n_blkrow
%                 for j=1:obj.n_blkcol
%                     result(i,j) = obj.C{i,j};
%                 end
%             end
%         end
%
        function [result] = as_symmatrix(obj)
            % creates symmatrix of blocks of SymbolicBlockMatrix
            % input validation
            assert(~isempty(obj), "Empty SymbolicBlockMatrix not allowed.")
            % do type conversion
            result = [obj.C{1,1}];
            for i=1:obj.n_blkrow
                for j=1:obj.n_blkcol
                    result(i,j) = obj.C{i,j};
                end
            end
        end
        
%         function [result] = col_get(obj, j)
%             % get j - th (block) column as BlockMatrix
%             %
%             result = BlockMatrix(obj.C{:, j});
%         end
% 
%         function [result] = row_get(obj, i)
%             % get i - th (block) row as BlockMatrix
%             %
%             result = BlockMatrix(obj.C{i, :})
%         end
% 
%         function [result] = col_set(obj, j)
%             % get j - th (block) column as BlockMatrix
%             %
%             result = BlockMatrix(obj.C{:, j})
%         end
% 
%         function [result] = row_get(obj, i)
%             % get i - th (block) row as BlockMatrix
%             %
%             result = BlockMatrix(obj.C{i, :})
%         end
        
        
        % Analogues of existing operators (`morally' overloading)
        function [result] = get_block(obj, i, j)
            % Inputs block indices
            % Outputs a matrix
            %

            result = obj.C{i, j};
        end

        function obj = set_block(obj, i, j, M)
            % Inputs block indices and a matrix being new block value
            % Outputs a BlockMatrix being the modified block matrix
            %

            obj.C{i, j} = M;
        end

        function result = n_blkcol(obj)
            result = size(obj.C, 2);
        end

        function result = n_blkrow(obj)
            result = size(obj.C, 1);
        end        
        
        function result = flat(obj)
            result = SymbolicBlockMatrix({cell2mat(obj.C)});
        end

        % Operations
        %%%% DOES NOT WORK CURRENTLY %%%%
%         function [result] = rmult_col_by(obj, j, M)
%             % Right-multiply j-th (block)column of a BlockMatrix by matrix 
%             % Input:
%             %   i: positive integer
%             %   M: matrix (plain)
%             %
%             % Output:
%             %   result: obj but with col i right-multiplied by M
%         
%             %%% Input validation - to be implemented
% 
%             %%% do function
%             obj.C(:,j) = cellfun(@(X) X * M, obj.C(:,j), 'UniformOutput', false);
%             result = obj;
% 
%         end
% 
%         function [result] = lmult_row_by(obj, i, M)
%             % Left-multiply i-th (block)row of a BlockMatrix by matrix 
%             % Input:
%             %   i: positive integer
%             %   M: matrix (plain)
%             %
%             % Output:
%             %   result: obj but with row j left-multiplied by M
%         
%             %%% Input validation - to be implemented
% 
%             %%% do function
% %             obj.C(i,:) = cellfun(@(X) M * BlockMatrix({X}), obj.C(i,:),
% %             'UniformOutput', false); %does not work for some types reason
%             
%             ncol = obj.n_blkcol;
%             for j=1:ncol
%                 obj.C{i,j} = M * BlockMatrix({obj.C{i,j}});
%             end
%             result = obj;
%             
%         end
%         %%%% END OF: DOES NOT WORK CURRENTLY %%%%
%         function [result] = BMblkdiag(obj, BM2)
%             % blkdiag for two BlockMatrix objects
%             % Inputs BlockMatrix objects
%             % Outputs BlockMatrix object
%               
%             [to be implemented]
%         end
        
        % Converting
        function result = as_matrix(obj)
            result = cell2mat(obj.C);
        end

        


        % displaying SymbolicBlockMatrix
        function [] = printblocks(obj)
            celldisp(obj.C)
        end
        %
        % todo to refactor from BlockMatrix to SymbolicBlockMatrix for
        % three functions:
        %   (1) as_readable_table_with_names 
        %   and its two variants: 
        %   (2) as_readable_table_with_names_only_cols, 
        %   (3) as_readable_table_with_names_only_rows.
        %
%         function [result] = as_readable_table_with_names_only_cols(obj)
%             % todo:to be implemented
%             % Idea below 
%             % Limitation: names only columns
%             % (implementation sketched for matrix that has 3 columns partitioned as (2,1)
%             % The actual implementation will have to get indices of
%             % partition
% 
%             ncol = obj.n_blkcol(); % get number of columns
%             blk_ncol(ncol) = 0; % allocate ncol entries vector 
%             
%             % get indices of partition into blocks
%             for i=1:ncol
%                 blk = obj.get_block(1,i);
%                 ncol_of_blk = size(blk, 2);
%                 blk_ncol(i) = ncol_of_blk;
%             end
%             blk_lastcol_ix = cumsum(blk_ncol); % blk_lastcol_ix(i) = index of last column of block i
%             
%             % build table with names of clusters of columns
%             % flat whole cell
%             flat_obj = cell2mat(obj);
%             % hconcat clusters of columns
%             % first columns
%             my_table = table();
%             my_table = addvars(my_table, flat_obj(:,1:blk_lastcol_ix(1)) ...
%                 ,'NewVariableNames','in_space_1');
%             % the remaining columns, if there are any
%             if ncol>1
%                 for i=2:ncol
%                     % hconcat next cluster of columns 
%                     my_table = addvars(my_table, flat_obj(:,(blk_lastcol_ix(i-1)+1):blk_lastcol_ix(i)) ...
%                     ,'NewVariableNames','in_space_' + string(i));
%                 end
%             end
%             result = my_table;
%         end %function
% 
%         
%         function result = as_readable_table_with_names(obj)
%             % Names cols and rows of a BlockMatrix.
%             % Limitations:
%             %   row name is displayed not that nicely
%             %   currently names cannot be controlled (to be implemented)
%             
%             %%% name cols
%             my_table = obj.as_readable_table_with_names_only_cols();
%             
%             %%% name rows
%             %
%             nrow = obj.n_blkrow(); % get number of rows
%             blk_nrow(nrow) = 0; % allocate nrow entries vector  
%             % get indices of partition into blocks
%             for i=1:nrow
%                 blk = obj.get_block(i,1); % use the block from the first column - any block would be ok but the first is ensured to exist
%                 nrow_of_blk = size(blk, 1);
%                 blk_nrow(i) = nrow_of_blk;
%             end
% %             blk_lastrow_ix = cumsum(blk_nrow); % blk_lastrow_ix(i) =
% %             index of last row of block i -- NOT USED AT THE MOMENT
%             
%             % do naming
%             my_rownames = strings(size(my_table, 1),1); % allocate vector for row names
%             curr_row_ix = 1; % index of currently renamed row
%             for i=1:nrow
%                 for j=1:blk_nrow(i)
%                     % name only first row of a block
%                     if j==1
%                         my_rownames(curr_row_ix) = "out_space_" + string(i);
%                     else
%                         my_rownames(curr_row_ix) = ".";
%                     end
%                     curr_row_ix = curr_row_ix + 1;
%                 end
%             end
%             my_table = addvars(my_table, my_rownames ...
%                 , 'Before','in_space_1' ...
%                 ,'NewVariableNames','OutSpaceName');
%             
%             % return result
%             result = my_table;
% 
%         end
    end
end