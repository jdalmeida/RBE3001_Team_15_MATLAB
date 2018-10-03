for i = 1:3
    x = ballInfo(i, 1);
    y = ballInfo(i, 2);
    z = ballInfo(i, 3);
    set(scatterHandles(i).handle, 'xdata', x, 'ydata', y,'zdata', z);
end