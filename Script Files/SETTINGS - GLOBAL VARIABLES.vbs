'COUNTY CUSTOM VARIABLES----------------------------------------------------------------------------------------------------
'The following variables are dynamically added via the installer. They can be modified manually to make changes without re-running the installer, but doing so should not be undertaken lightly.

'Default directory: used by the script to determine if we're scriptwriters or not (scriptwriters use a default directory traditionally).
'	This is modified by the installer, which will determine if this is a scriptwriter or a production user.
default_directory = "C:\PRISM-Scripts\Script Files\"

'This is used for determining whether script_end_procedure will also log usage info in an Access table.
collecting_statistics = False

'This is the file path for the statistics Access database.
stats_database_path = "Q:\Blue Zone Scripts\Statistics\usage statistics.accdb"

'This is used by scripts which tell the worker where to find a doc to send to a client (ie "Send form using Compass Pilot")
EDMS_choice = "Compass Pilot"

'This is used for MEMO scripts, such as appointment letter
county_name = "Anoka County"

'Creates a double array of county offices, first by office (using the ~), then by address line (using the |). Dynamically added with the installer.
county_office_array = split("2100 3rd Ave Suite 400|Anoka, MN 55303", "~")

'This is a variable which signifies the agency is beta (affects script URL)
beta_agency = True

'An array of county attorneys. "Select one:" should ALWAYS be in there, and ALWAYS be first.
county_attorney_array = array("Select one:", "Tonya D.F. Berzat", "Michael S. Barone", "Paul C. Clabo", "Dorrie B. Estebo", "Francine Mocchi", "Rachel Morrison", "D. Marie Sieber", "Brett Shading")  

'ACTIONS TAKEN BASED ON COUNTY CUSTOM VARIABLES------------------------------------------------------------------------------

'Making a list of offices to be used in various scripts
For each office in county_office_array
	new_office_array = split(office, "|")									'Assigned earlier in the FUNCTIONS FILE script. Splits into an array, containing each line of the address.
	comma_location_in_address_line_02 = instr(new_office_array(1), ",")				'Finds the location of the first comma in the second line of the address (because everything before this is the city)
	city_for_array = left(new_office_array(1), comma_location_in_address_line_02 - 1)		'Pops this city into a variable
	county_office_list = county_office_list & chr(9) & city_for_array					'Adds the city to the variable called "county_office_list", which also contains a new line, so that it works correctly in dialogs.
Next


is_county_collecting_stats = collecting_statistics	'IT DOES THIS BECAUSE THE SETUP SCRIPT WILL OVERWRITE LINES BELOW WHICH DEPEND ON THIS, BY SEPARATING THE VARIABLES WE PREVENT ISSUES

'The following code looks in C:\USERS\''windows_user_ID''\My Documents for a text file called workersig.txt.
'If the file exists, it pulls the contents (generated by ACTIONS - UPDATE WORKER SIGNATURE.vbs) and populates worker_signature automatically.
Set objNet = CreateObject("WScript.NetWork") 
windows_user_ID = objNet.UserName

'Loads worker sig
Dim oTxtFile 
With (CreateObject("Scripting.FileSystemObject"))
	If .FileExists("C:\users\" & windows_user_ID & "\my documents\workersig.txt") Then
		Set get_worker_sig = CreateObject("Scripting.FileSystemObject")
		Set worker_sig_command = get_worker_sig.OpenTextFile("C:\users\" & windows_user_ID & "\my documents\workersig.txt")
		worker_sig = worker_sig_command.ReadAll
		IF worker_sig <> "" THEN worker_signature = worker_sig	
		worker_sig_command.Close
	END IF
END WITH

'This is the URL of our script repository, and should only change if the agency is beta or standard, or if there's a scriptwriter in the group (which is determined by the default directory being C:\PRISM-Scripts\Script Files.
If default_directory = "C:\PRISM-Scripts\Script Files\" then
	script_repository = "https://raw.githubusercontent.com/MN-CS-Script-Team/PRISM-Scripts/master/Script Files/"
Else
	If beta_agency = True then
		script_repository = "https://raw.githubusercontent.com/MN-CS-Script-Team/PRISM-Scripts/beta/Script Files/"
	Else
		script_repository = "https://raw.githubusercontent.com/MN-CS-Script-Team/PRISM-Scripts/release/Script Files/"
	End if
End if
