//TextColumn class
function TextColumn(headerText, dataField, width) {
    if (typeof headerText !== 'undefined') this.headerText = headerText;
    if (typeof dataField !== 'undefined') this.dataField = dataField;
    if (typeof width !== 'undefined') this.width = width;
}

//Grid class
function Grid(id, parentDiv) {
    if (typeof id !== 'undefined') this.id = id;
    if (typeof parentDiv !== 'undefined') this.parentDiv = parentDiv;
    this.columns = []; //grid columns
    this.dataSource = null; //grid data

    //add columns to grid
    Grid.prototype.addColumn = function(column) {
        this.columns[this.columns.length] = column;
    }

    //set data source
    Grid.prototype.setDataSource = function(dataSource) {
        this.dataSource = dataSource;
    }

    //show table
    Grid.prototype.show = function() {
        console.log(this.columns);
        //create table
        var table = document.createElement('table');
        table.id = this.id;
        table.className = 'grid';
        //table header
        var tableHeader = document.createElement('thead');
        tableHeader.id = this.id + 'header';
        table.appendChild(tableHeader);
        //table body
        var tableBody = document.createElement('tbody');
        tableBody.id = this.id + 'body';
        table.appendChild(tableBody);
        //add table to parent
        parentDiv.appendChild(table);
        //add columns
        for (var i = 0; i < this.columns.length; i++) {
            var th = document.createElement('th');
            th.innerHTML = this.columns[i].headerText;
            th.setAttribute('width', this.columns[i].width);
            tableHeader.appendChild(th);
        }
        //show data rows
        console.log(this.dataSource);
        for (var i = 0; i < this.dataSource.length; i++) {
            //create row
            var row = document.createElement('tr');
            //read columns
            for (var c = 0; c < this.columns.length; c++) {
                //create cell
                var cell = document.createElement('td');
                //cell.innerHTML = this.dataSource[i]['firstName']; OK!
                //cell.innerHTML = this.dataSource[i]['name.firstName']; WRONG!
                //cell.innerHTML = this.dataSource[i]['name']['firstName']; OK!
                if (this.columns[c] instanceof TextColumn) {
                    cell.innerHTML = this.dataSource[i][this.columns[c].dataField];
                }
                row.appendChild(cell);
            }
            //add row to table body
            tableBody.appendChild(row);
        }
    }
}