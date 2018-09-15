classdef CSVWriter
    %% This class simplifies the writing to and from csvs by incrementing file names
    
    properties

    end
    methods
        function obj = CSVWriter()
            %CSVWRITER Construct an instance of this class
            %   Detailed explanation goes here
        end
        %% This function needs to go through the files and see if the
            % numeric form of the csv exists and keep adding 1 til its not
            % there
        function name=BeginCsv(varargin)
            if nargin > 0
                initCsvName=varargin{2};
                i=0;
                newCsvName = sprintf('Binaries/%s%d.csv', initCsvName, i);
                while exist(newCsvName, 'file') == 2
                    i=i+1;
                    newCsvName = sprintf('Binaries/%s%d.csv', initCsvName, i);
                end
                name=newCsvName;
            else
                error('gib name plz');
            end
            
        end
        %% put file name then data
        function AppendCsv(varargin)
            nameCsv=varargin{2};
            data=varargin{3};
            
                dlmwrite(nameCsv, data,'-append');
        end
    end
end

