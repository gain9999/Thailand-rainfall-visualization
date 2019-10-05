#This python function reads NetCDF files downloaded from CHRS Data Portal (http://chrsdata.eng.uci.edu/)
#netCDF4 and collections libraries are required

from netCDF4 import Dataset
from collections import OrderedDict

# by Phu Nguyen, Hoang Tran, 09-13-2016, contact: ndphu@uci.edu
# Reading satellite precipitation data in NetCDF format downloaded from 
# UCI CHRS's DataPortal(chrsdata.eng.uci.edu)
# Data domain: see info.txt file in the downloaded package for detailed information

def read_netcdf(netcdf_file):
	contents = OrderedDict()
	data = Dataset(netcdf_file, 'r')
	for var in data.variables:
		attrs = data.variables[var].ncattrs()
		if attrs:
			for attr in attrs:
				print '\t\t%s:' % attr,\
                      repr(data.variables[var].getncattr(attr))
		contents[var] = data.variables[var][:]
	data = contents['precip']
	if len(data.shape) == 3:
		data = data.swapaxes(0,2)
		data = data.swapaxes(0,1)
		return data
	else:
		return data