use sysinfo::{Disks, System};

pub struct DiskSpaceInfo {
    pub path: String,
    pub total: u64,
    pub available: u64,
}

#[flutter_rust_bridge::frb(sync)]
pub fn get_disk_space_infos() -> Vec<DiskSpaceInfo> {
    Disks::new_with_refreshed_list().list().iter().map(|disk| {
        return DiskSpaceInfo {
            path: disk.mount_point().to_str().unwrap().to_string(),
            total: disk.total_space(),
            available: disk.available_space(),
        };
    })
        .collect::<Vec<DiskSpaceInfo>>()
}