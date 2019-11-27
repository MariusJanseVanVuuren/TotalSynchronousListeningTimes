# TotalSynchronousListeningTimes


This project read a list of floaring point values from an array.
These floating point values are to represent the listening times of a user to a specific radio station. 
The system will then, if it can successfully read the data, determine the total synchronous listening time of a user.
 It does so by :
- removing any duplicated sessions, removing any sessions contained within larger overlapping session, 
- Removing sessions which start and end between the end and start time of other listening times.
- After all duplicates have been created we remove any over lapping time 
- Finally we calculate the total time of the unique time periods.

A bar graph drawn on a CALayer of the overlapping times.
We also display a list of listening times to the user through the use of child view controllers using the better MVC architecture pattern.

Unit tests where added for the most critical business logic items for determining unique times.
