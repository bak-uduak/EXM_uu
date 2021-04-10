/*****************************************************************************************************************
NAME:    [dbo].[tblData]
PURPOSE: Create the [dbo].[tblData] table

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     03/27/2021    UUDO       1. Built this table for LDS BC IT240


RUNTIME: 
Approx. 0 min

NOTES:
This is a denormalized data set for a ficticious soccer team

LICENSE: This code is covered by the GNU General Public License which guarantees end users
the freedom to run, study, share, and modify the code. This license grants the recipients
of the code the rights of the Free Software Definition. All derivative work can only be
distributed under the same license terms.
 
******************************************************************************************************************/

USE [EXM]
GO

/****** Object:  Table [dbo].[tblData]    Script Date: 8/2/2019 11:34:31 PM ******/
DROP TABLE [dbo].[tblData]
GO

/****** Object:  Table [dbo].[tblData]    Script Date: 8/2/2019 11:34:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblData](
	[pl_id] [int] NOT NULL,
	[l_name] [varchar](50) NOT NULL,
	[f_name] [varchar](50) NOT NULL,
	[pl_name] [varchar](100) NOT NULL,
	[t_id] [int] NOT NULL,
	[p_id] [int] NOT NULL,
	[pl_num] [int] NOT NULL,
	[p_code] [varchar](5) NOT NULL,
	[p_name] [varchar](50) NOT NULL,
	[p_target] [int] NOT NULL,
	[t_code] [varchar](5) NOT NULL
) ON [PRIMARY]
GO

