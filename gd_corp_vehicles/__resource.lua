files {
    'stream/cabs/vehicles.meta',
    'stream/collinsco/vehicles.meta',
    'stream/frllc/vehicles.meta',
    'stream/narwhalcorp/vehicles.meta',
    'stream/postop/vehicles.meta',
    'stream/sal/vehicles.meta',
    'carvariations.meta',
    'handling.meta'
}

data_file 'HANDLING_FILE' 'handling.meta'

data_file 'VEHICLE_METADATA_FILE' 'stream/cabs/vehicles.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/collinsco/vehicles.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/frllc/vehicles.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/narwhalcorp/vehicles.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/postop/vehicles.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/sal/vehicles.meta'

data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'

client_script 'vehicle_names.lua'
