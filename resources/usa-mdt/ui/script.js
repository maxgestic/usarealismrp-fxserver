const mdtApp = new Vue({
    el: "#content_container",
    data: {
        employee: {
            fname: "",
            lname: "",
            rank: ""
        },
        person_check: {
            ssn: null,
            name: null,
            drivers_license: null,
            firearm_permit: null,
            insurance: null,
            criminal_history: {
                crimes: null,
                tickets: null
            }
        },
        plate_check: {
            search_input: null,
            registered_owner: null,
            veh_name: null,
            plate: null
        },
        warrants: [],
        bolos: [],
        police_reports: [],
        warrant_search: "",
        bolo_search: "",
        report_search: "",
        new_bolo: {
            description:  ""
        },
        new_warrant: {
            first_name: "",
            last_name: "",
            last_name: "",
            charges: "",
            suspect_description:  "",
            police_report_number: ""
        },
        new_police_report: {
            incident: "",
            location: "",
            other_responders: ""
        },
        current_warrant: {
            first_name: "",
            last_name: "",
            last_name: "",
            charges: "",
            suspect_description:  "",
            police_report_number: ""
        },
        current_report: {
            incident: "",
            location: "",
            other_responders: ""
        },
        error: null,
        notification: null,
        current_tab: "Person(s) Check" // default tab
    },
    methods: {
        PerformPersonCheck() {
            if (this.person_check.ssn != 0 && this.person_check) {
                /* request person info */
                $.post('http://usa-mdt/PerformPersonCheck', JSON.stringify({
                    ssn: this.person_check.ssn
                }));
            }
        },
        PerformPlateCheck() {
            /* request person info */
            $.post('http://usa-mdt/PerformPlateCheck', JSON.stringify({
                plate: this.plate_check.search_input
            }));
        },
        changePage(new_page) {
            this.error = null;
            this.notification = null;
            this.current_tab = new_page;
            /* Clear active nav tab */
            ClearActiveNavItem(new_page);
            if (new_page == "Warrants") {
                /* request outstanding warrants */
                $.post('http://usa-mdt/fetchWarrants', JSON.stringify({}));
                $("#warrants").addClass("nav-active");
            } else if (new_page == "BOLO") {
                /* request BOLOs */
                $.post('http://usa-mdt/fetchBOLOs', JSON.stringify({}));
                $("#bolo").addClass("nav-active");
            } else if (new_page == "Person(s) Check") {
                $("#person_check").addClass("nav-active");
            } else if (new_page == "Plate Check") {
                $("#plate_check").addClass("nav-active");
            } else if (new_page == "Police Reports") {
                $.post('http://usa-mdt/fetchPoliceReports', JSON.stringify({}));
                $("#reports").addClass("nav-active");
            }
        },
        CreateBOLO() {
            if (this.new_bolo.description != "") {
                $.post('http://usa-mdt/createBOLO', JSON.stringify({
                    bolo: this.new_bolo
                }));
                this.notification = "BOLO created!";
                this.new_bolo.description = "";
            } else {
                this.notification = "Please fill in all required fields!";
            }
        },
        CreateWarrant() {
            if (this.new_warrant.first_name != "" && this.new_warrant.last_name != "" && this.new_warrant.charges != "") {
                $.post('http://usa-mdt/createWarrant', JSON.stringify({
                    warrant: this.new_warrant
                }));
                this.notification = "Warrant created successfully for: " + this.new_warrant.first_name + " " + this.new_warrant.last_name;
                this.new_warrant.first_name = "";
                this.new_warrant.last_name = "";
                this.new_warrant.charges = "";
                this.new_warrant.suspect_description = "";
                this.new_warrant.police_report_number = "";
            } else {
                this.notification = "Please fill in all required fields!";
            }
        },
        CreatePoliceReport() {
            if (this.new_police_report.incident != "" && this.new_police_report.location != "") {
                $.post('http://usa-mdt/CreatePoliceReport', JSON.stringify({
                    report: this.new_police_report
                }));
                this.notification = "Incident report created!";
                this.new_police_report.incident = "";
                this.new_police_report.location = "";
                this.new_police_report.other_responders = "";
            } else {
                this.notification = "Please fill in all required fields!";
            }
        },
        OpenWarrantDetails(uuid) {
            for (var key in this.warrants) {
                if (uuid == this.warrants[key]._id) {
                    this.error = "";
                    this.current_warrant = this.warrants[key];
                    this.current_tab = "Warrant Detail";
                    return;
                }
            }
            this.error = "Error: did not find a matching warrant for that uuid!";
        },
        OpenPoliceReportDetails(uuid) {
            for (var key in this.police_reports) {
                if (uuid == this.police_reports[key]._id) {
                    this.error = "";
                    this.current_report = this.police_reports[key];
                    this.current_tab = "Incident Detail";
                    return;
                }
            }
            this.error = "Error: did not find a matching police report for that uuid!";
        },
        DeleteWarrant(uuid) {
            for (var index in this.warrants) {
                if (uuid == this.warrants[index]._id) {
                    $.post('http://usa-mdt/deleteWarrant', JSON.stringify({
                        warrant_id: this.warrants[index]._id,
                        warrant_rev: this.warrants[index]._rev
                    }));
                    this.warrants.splice(index, 1);
                    this.error = "Warrant deleted!";
                    this.current_tab = "Warrants";
                    return;
                }
            }
            this.error = "Error: did not find a matching warrant for that uuid!";
        },
        DeleteBOLO(uuid) {
            for (var index in this.bolos) {
                if (uuid == this.bolos[index]._id) {
                    $.post('http://usa-mdt/deleteBOLO', JSON.stringify({
                        bolo_id: this.bolos[index]._id,
                        bolo_rev: this.bolos[index]._rev
                    }));
                    this.bolos.splice(index, 1);
                    this.error = "BOLO deleted!";
                    this.current_tab = "BOLO";
                    return;
                }
            }
            this.error = "Error: did not find a matching BOLO for that uuid!";
        },
        DeletePoliceReport(uuid) {
            for (var index in this.police_reports) {
                if (uuid == this.police_reports[index]._id) {
                    $.post('http://usa-mdt/deletePoliceReport', JSON.stringify({
                        police_report_id: this.police_reports[index]._id,
                        police_report_rev: this.police_reports[index]._rev
                    }));
                    this.police_reports.splice(index, 1);
                    this.error = "Police report deleted!";
                    this.current_tab = "Police Reports";
                    return;
                }
            }
            this.error = "Error: did not find a matching police report with that uuid!";
        }
    },
    computed: {
        filtered_warrants() {
            return this.warrants.filter(warrant => {
                var fullname = warrant.first_name + " " + warrant.last_name;
                if (fullname.toLowerCase().search(this.warrant_search.toLowerCase()) != -1)
                    return warrant
            })
        },
        filtered_bolos() {
            return this.bolos.filter(bolo => {
                if (bolo.description.toLowerCase().search(this.bolo_search.toLowerCase()) != -1)
                    return bolo;
            })
        },
        filtered_police_reports() {
            return this.police_reports.filter(report => {
                if (
                    report.incident.toLowerCase().search(this.report_search.toLowerCase()) != -1 ||
                    report._id.toLowerCase().search(this.report_search.toLowerCase()) != -1
                    )
                    return report;
            })
        }
    }
});

document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {
            if (event.data.type == "enable") {
                /* show / hide mdt */
                document.body.style.display = event.data.isVisible ? "block" : "none";
                /* get rank */
                if (mdtApp.employee.lname == "" && event.data.isVisible) {
                    $.post('http://usa-mdt/fetchEmployee', JSON.stringify({}));
                }
            } else if (event.data.type == "personInfoLoaded") {
                /* fill person info data */
                mdtApp.person_check = event.data.person_info;
                /* hide error message */
                mdtApp.error = null;
            } else if (event.data.type == "plateInfoLoaded") {
                /* fill plate info data */
                mdtApp.plate_check.registered_owner = event.data.plate_info.registered_owner;
                mdtApp.plate_check.veh_name = event.data.plate_info.veh_name;
                mdtApp.plate_check.plate = event.data.plate_info.plate;
                /* hide error message */
                mdtApp.error = null;
            } else if (event.data.type == "warrantsLoaded") {
                mdtApp.warrants = event.data.warrants;
            } else if (event.data.type == "bolosLoaded") {
                mdtApp.bolos = event.data.bolos;
            } else if (event.data.type == "employeeLoaded") {
                mdtApp.employee = event.data.employee;
            }else if (event.data.type == "policeReportsLoaded") {
                mdtApp.police_reports = event.data.police_reports;
            } else if (event.data.type == "warrantInfo") {
                /* warrant created successfully, fetch again to update list */
                $.post('http://usa-mdt/fetchWarrants', JSON.stringify({}));
            } else if (event.data.type == "bolo_created") {
                $.post('http://usa-mdt/fetchBOLOs', JSON.stringify({}));
            } else if (event.data.type == "police_report_created") {
                $.post('http://usa-mdt/fetchPoliceReports', JSON.stringify({}));
            }else if (event.data.type == "error") {
                /* display error message */
                mdtApp.error = event.data.message;
                /* clear fields */
                if  (mdtApp.current_tab == "Person(s) Check") {
                    mdtApp.person_check = {
                            ssn: null,
                            name: null,
                            drivers_license: null,
                            firearm_permit: null,
                            insurance: null,
                            criminal_history: {
                                crimes: null,
                                tickets: null
                            }
                        }
                } else if (mdtApp.current_tab == "Plate Check") {
                    mdtApp.plate_check = {
                        search_input: null,
                        registered_owner: null,
                        veh_name: null,
                        plate: null
                    }
                }
            }
        });
    };
};

document.onkeydown = function (data) {
    if (data.which == 27 || data.which == 112) { // ESC or F1
        $.post('http://usa-mdt/close', JSON.stringify({}));
    } else if (data.which == 13) { // enter
        /* prevent enter key from closing MDT for some reason */
        return false;
    }
};

function ClearActiveNavItem() {
    $("#plate_check").removeClass("nav-active");
    $("#person_check").removeClass("nav-active");
    $("#warrants").removeClass("nav-active");
    $("#bolo").removeClass("nav-active");
    $("#reports").removeClass("nav-active");
}
