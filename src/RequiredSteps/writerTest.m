fileName='test';
myWriter=CSVWriter();
fileName=myWriter.BeginCsv(fileName)
data=[1 1];
myWriter.AppendCsv(fileName, data);
