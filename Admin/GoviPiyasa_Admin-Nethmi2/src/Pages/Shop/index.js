import axios from "axios";
import { useEffect, useState } from "react";
import "../../App.css";
import * as React from "react";
import { DataGrid } from "@mui/x-data-grid";
import Preview from "./preview";
import { IconButton, Rating} from "@mui/material";
import { Box } from "@mui/system";
import DeleteIcon from "@mui/icons-material/Delete";
import TextField from '@mui/material/TextField';
import ClearIcon from '@mui/icons-material/Clear';
import SearchIcon from '@mui/icons-material/Search';
import RemoveRedEyeIcon from '@mui/icons-material/RemoveRedEye';
import BlockIcon from '@mui/icons-material/Block';
import { Badge } from "react-bootstrap";
import AlertMsg from "../../Components/Alert";


const Shop = () => {

  const user_token = window.localStorage.getItem("token");
  //const [search, setSearch] = useState(null);
  const [hoveredRow, setHoveredRow] = useState(null);
  const [tableData, setTableData] = useState([]);
  const [show, setShow] = useState(false);
  const [open, setOpen] = useState(false);
  const [platform, setPlatform] = useState([]);
  const [searchText, setSearchText] = useState('');
  const [status, setStatus] = useState(true);

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);

  const handleClose2 = () => {
    setOpen(false);
  };

  const handleDelete = (id) => {
    try{
      axios.delete("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/"+id)
      .then(() => {
        setTableData(tableData.filter((data) => data._id !== id));
        setOpen(true);
        //alert("Deleted!");
        console.log(id);
      })   
    }
    catch{

    }
  };

  //search function
  function escapeRegExp(value) {
    return value.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
  }
  const requestSearch = (searchValue) => {
    const searchRegex = new RegExp(escapeRegExp(searchValue), 'i');
    const filteredRows = platform.filter((row) => {
      
        return searchRegex.test(row.userName);
    });
    setTableData(filteredRows);
  };

  const handleView = async (id) => {
      try {
        console.log(id);
        const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/"+id);
        handleShow();
        console.log(data);
      } catch (e) {
        console.log(e);
      }
    };



  const handleSuspend = (id, status) => {
    try{
      console.log("status "+status);
      if(status === "Active"){
        console.log(status);
        setStatus("Suspend");
      }
      axios.put("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/setShopVisibility/"+id, status);
    }
    catch{

    }
  }


  const onMouseEnterRow = (event) => {
    const id = event.currentTarget.getAttribute("data-id");
    setHoveredRow(id);
  };

  const onMouseLeaveRow = (event) => {
    setHoveredRow(null);
  };

  const getData = async () => {
    try {
      console.log("shops");
      const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/getUsersShop",
      { headers : 
        {'Authorization' : `Bearer ${user_token}`}
      });
      setTableData(data.data.data);
      console.log(data.data.data);
    } catch (e) {
      console.log(e);
    }
  };

  useEffect(()=>{
    getData();
  },[])



  //initialize columns 
  
  const columns = [

    { field: 'shopName', headerName: 'Shop', width: 150 },
    // { field: 'userName', headerName: 'Name', width: 150 ,
    //   valueGetter: (params) => {
    //     return params.getValue(params.id, "user").userName;
    //   }
    // },
    { field: 'email', headerName: 'Email', width: 170},
    // { field: 'city', headerName: 'City', width: 100 ,
    //   valueGetter: (params) => {
    //     return params.getValue(params.id, "googlelocation").city;
    //   }
    // },
    // { field: 'contactNumber', headerName: 'Contact No', width: 100 ,
    //   valueGetter: (params) => {
    //     return params.getValue(params.id, "user").contactNumber;
    //   }
    // },
    { field: 'itemCount', headerName: 'No of items', width: 100 },
    { field: 'rating', headerName: 'Rating', width: 120,
        renderCell: (params) => { 
          return(
            <Rating name="read-only" size="small" value={params.getValue(params.id,'rating')} precision={0.5} readOnly />
          );
        }
    },
    { field: 'shopVisibiliy', headerName: 'Status', width: 100, value:'Active' ,sortable: false,
      renderCell: (params) => { 
        return(
          params.getValue(params.id,'shopVisibility') ==="Active" ?   <Badge pill bg="success">Active</Badge> : 
          (params.getValue(params.id,'shopVisibility')==="Inactive" ? <Badge pill bg="danger">Not Active</Badge> :
          (params.getValue(params.id,'shopVisibility')==="Pending" ? <Badge pill bg="primary">Pending</Badge> :
          (params.getValue(params.id,'shopVisibility')==="Suspend" ? <Badge pill bg="warning" text="dark">Suspend</Badge> : 
                                                                    <Badge pill bg="secondary">Rejected</Badge>)))
        );
      }
    },
    { field: "actions", headerName: "Actions", width: 120, sortable: false, disableColumnMenu: true,
      renderCell: (params) => {
        if (hoveredRow === params.id) {
          return (
            <Box
              sx={{ backgroundColor: "whitesmoke", width: "100%", height: "100%", display: "flex",
                justifyContent: "center", alignItems: "center"
              }}
            >
              <IconButton>
                <BlockIcon color="warning" onClick={() => handleSuspend(params.id, params.getValue(params.id,'shopVisibility'))}/>
              </IconButton>
              <IconButton onClick={() => handleDelete(params.id)}>
                <DeleteIcon color="error" />
              </IconButton>
              <IconButton onClick={() => handleView(params.id)}>
                <RemoveRedEyeIcon color="info"/>
              </IconButton>

              <Preview show={show} id={params.id} handleClose={handleClose}/>
            </Box>
          );
        } else return null;
      }
    }
  ]




  return (
    <div className="content">
      <h3>Shop list</h3>
      
      <Box>
        <TextField variant="standard" value={searchText}
          onChange={(e) => { setSearchText(e.target.value); requestSearch(e.target.value) }}
          placeholder="Search..."
            InputProps={{
              startAdornment: <SearchIcon fontSize="small" color="action" />,
              endAdornment: (
                <IconButton title="Clear" aria-label="Clear" size="small"
                  style={{ visibility: searchText ? 'visible' : 'hidden', borderRadius: "57%", paddingRight: "1px", margin: "0", fontSize: "1.25rem" }}
                  onClick={(e) => {setSearchText(''); setTableData(platform)} }
                >
                  <ClearIcon fontSize="small" color="action" />
                </IconButton>
              ),
            }}
            sx={{ width: { xs: 1, sm: 'auto' }, m: (theme) => theme.spacing(1, 1.5, 1.5, 2.5),
                  '& .MuiSvgIcon-root': { mr: 0.5 },
                  '& .MuiInput-underline:before': { borderBottom: 1, borderColor: 'divider', },
            }}
        />
      </Box>
      

      <div style={{ height: 500, width: "100%", padding: "1em" }}>
        <DataGrid
          rows={tableData}
          columns={columns}
          getRowId={(row) => row._id}
          pageSize={10}
          rowsPerPageOptions={[10]}
          checkboxSelection
          disableSelectionOnClick
          initialState={{ pinnedColumns: { right: ['actions'] } }}
          componentsProps={{
            row: {
              onMouseEnter: onMouseEnterRow,
              onMouseLeave: onMouseLeaveRow
            }
          }}
        >  
        </DataGrid>
      </div>
      <AlertMsg open={open} msg="Deleted" handleClose={handleClose2}/>
    </div>
  );
};

export default Shop;
