fileName='test';
myWriter=CSVWriter();
fileName=myWriter.BeginCsv(fileName)

for i=1:15
    data=[1 1 i 5];
    myWriter.AppendCsv(fileName, data);
end