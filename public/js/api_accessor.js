function registUser() {
    var uid = $('#uid').val();
    var kind = $('#kind').val();
    var id = $('#id').val();

    var data = {
        uid: uid,
        type: kind,
        id: id
    };

    $.ajax({
        url: '/api/user/create/',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify(data),
        success: function(json_data) {
            location.reload();
            alert("ok");
        },
        error: function(XMLHTTPRequest, textStatus, errorThrown) {
            alert("error");
        }
    });
}

function registPassby() {
    var input = document.getElementById("csvfile");
    var reader = new FileReader();
    reader.onload = function (event) {
        data = postPassingCsv(event.target.result);
        $.ajax({
            type: "post",
            url: "/api/passby/create_multi/",
            data: JSON.stringify(data),
            contentType: 'application/json',
            dataType: 'json',
            success: function(json_data) {
                location.reload();
                alert("ok");
            },
            error: function(XMLHTTPRequest, textStatus, errorThrown) {
                alert("error");
            }
        });
    };
    reader.readAsText(input.files[0], "utf-8");
}
function postPassingCsv(csv) {
    var csvArray = csv.split('\n');
    var columns = ['datetime', 'object_1', 'object_2'];
    var jsonArray = [];
    for (var i=0; i<csvArray.length - 1; i++) {
        var json = new Object();
        var csvRow = csvArray[i].split(',');
        for(var j=0; j<columns.length; j++) {
            json[columns[j]] = csvRow[j];
        }
        jsonArray.push(json);
    }
    console.log(jsonArray);
    return jsonArray;
}

function getPassby() {
    var uid = $('#uid').val();
    var date = $('#date').val();
    var times = $('#times').val();
    var with_id = $('#with').val();

    $.ajax({
        type: "GET",
        url: "/api/passby/search/",
        contentType: 'application/json',
        data: {
            object_1: uid,
            datetime: date,
            times: times,
            object_2: with_id
        },
        dataType: 'json',
        success: function(json_data) {
            console.log(json_data);
            data_array = JSON.parse(json_data).list;
            console.log(data_array);
            $("#table tbody *").remove();
            $.each(data_array, function(i) {
                $("#table").prepend('<tr><td>' + data_array[i].datetime + '</td><td>' + data_array[i].object2 + '</td></tr>');
            })
        },
        error: function() {
            alert("error");
        }
    })
}