function data = read_netcdf(file_name)
% by Phu Nguyen, Hoang Tran, 09-13-2016, contact: ndphu@uci.edu
% Reading satellite precipitation data in NetCDF format downloaded from 
% UCI CHRS's DataPortal(chrsdata.eng.uci.edu)
% Data domain: see info.txt file in the downloaded package for detailed information

ncid=netcdf.open(file_name,'nowrite');
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);

for i = 0:numvars-1
    [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,i);
    flag = 0;
    for j = 0:numatts - 1
        attname1 = netcdf.inqAttName(ncid,i,j);
        attname2 = netcdf.getAtt(ncid,i,attname1);
        disp([attname1 ':  ' num2str(attname2)])
        if strmatch('add_offset',attname1)
            offset = attname2;
        end
        if strmatch('scale_factor',attname1)
            scale = attname2;
            flag = 1;
        end
    end
    
    if flag
        eval([varname '= double(double(netcdf.getVar(ncid,i))*scale + offset);'])
    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])
    end
    
end
netcdf.close(ncid);
data=permute(precip,[2,1,3]);