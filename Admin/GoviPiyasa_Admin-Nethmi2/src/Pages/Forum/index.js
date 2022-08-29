import axios from "axios";
import { useEffect, useState } from "react";
import "../../App.css";
import * as React from "react";
import { DataGrid } from '@mui/x-data-grid';
import Preview from "./preview";
import { IconButton} from "@mui/material";
import { Box } from "@mui/system";
import DeleteIcon from "@mui/icons-material/Delete";
import RemoveRedEyeIcon from '@mui/icons-material/RemoveRedEye';
import BlockIcon from '@mui/icons-material/Block';
import RemoveCircleOutlineIcon from '@mui/icons-material/RemoveCircleOutline';
import TextField from '@mui/material/TextField';
import ClearIcon from '@mui/icons-material/Clear';
import SearchIcon from '@mui/icons-material/Search';
import Tooltip from '@mui/material/Tooltip';
import { Badge } from "react-bootstrap";


const Forum = () => {
  //const [search, setSearch] = useState("");
  const [hoveredRow, setHoveredRow] = useState(null);
  const [tableData, setTableData] = useState([]);
  const [show, setShow] = useState(false);
  const [platform, setPlatform] = useState([]);
  const [searchText, setSearchText] = useState('');

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);


  const onMouseEnterRow = (event) => {
    const id = event.currentTarget.getAttribute("data-id");
    setHoveredRow(id);
  };

  const onMouseLeaveRow = (event) => {
    setHoveredRow(null);
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
      handleShow();
    } catch (e) {
      console.log(e);
    }
  };

  const handleDelete = (id) => {
    setTableData(tableData.filter((data) => data._id !== id));
    console.log(id);
  };

  const handleBlock = async (id) => {
    const response = await axios.put("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/BlockQuestion/"+id);
    if(response){
      getAllData();
    }
  }

  const handleUnblock = async (id) => {
    const response = await axios.put("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/UnblockQuestion/"+id);
    if(response){
      getAllData();
    }
  }


  const getAllData = async () => {
    try {
      const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/");
      setTableData(data.data.data);
    } catch (e) {
      console.log(e);
    }
  };

  useEffect(()=>{
    getAllData();
  },[])

  
  
  const columns = [

    { field: 'Category', headerName: 'Category', width:130 },
    { field: 'Title', headerName: 'Title', width:250 },
    { field: 'QuestionBody', headerName: 'Question', width: 320},
    { headerName: 'View Answer', width: 100, sortable: false,
      
      renderCell: (params) => {
        
        if (hoveredRow === params.id) {
          return (
          <Box
            sx={{ width: "100%", height: "100%", display: "flex", justifyContent: "center", alignItems: "center"
            }}
          >
            <IconButton onClick={() => handleView(params.id)}>
              <RemoveRedEyeIcon color="info"/>
            </IconButton>
            <Preview show={show} id={params.id} handleClose={handleClose}/>
          </Box>
        );
      }
    }},
    
    { field: 'status', headerName: 'Status', width: 100,
      renderCell: (params) => { 
        return(
          params.getValue(params.id,'status') === true ?   <Badge pill bg="primary">Enable</Badge> : <Badge pill bg="secondary">Disable</Badge>
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
              <Tooltip title={params.getValue(params.id,'status') === true ? "Block" : "Unblock"}  arrow>
                <IconButton onClick={() => params.getValue(params.id,'status') === true ? handleBlock(params.id) : handleUnblock(params.id)}>
                  {params.getValue(params.id,'status') === true ? <BlockIcon color="warning" /> : <RemoveCircleOutlineIcon color="warning"/>}
                </IconButton>
              </Tooltip>

              <IconButton onClick={() => handleDelete(params.id)}>
                <DeleteIcon color="error" />
              </IconButton>
              
            </Box>
          );
        } else return null;
      }
    }
    
  ]

 

  return (
    <div className="content">
      <h3>QnA Forum</h3>
      
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
          componentsProps={{
            row: {
              onMouseEnter: onMouseEnterRow,
              onMouseLeave: onMouseLeaveRow
            }
          }}
        >  
        </DataGrid>
      </div>
    </div>
  );
};

export default Forum;
