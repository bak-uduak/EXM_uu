USE master;
GO

IF EXISTS
(
    SELECT name
      FROM sys.databases
     WHERE name = 'EXM'
)
    BEGIN
        ALTER DATABASE EXM SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
        DROP DATABASE EXM;
END;

CREATE DATABASE EXM;
GO






USE [EXM]
GO
/****** Object:  Table [dbo].[tblData]    Script Date: 8/3/2019 1:47:18 AM ******/
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
/****** Object:  Table [dbo].[tblPlayerDim]    Script Date: 8/3/2019 1:47:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPlayerDim](
	[pl_id] [int] NOT NULL,
	[l_name] [varchar](50) NOT NULL,
	[f_name] [varchar](50) NOT NULL,
	[pl_name] [varchar](100) NOT NULL,
	[t_id] [int] NOT NULL,
	[p_id] [int] NOT NULL,
	[pl_num] [int] NOT NULL,
 CONSTRAINT [PK_tblPlayerDim] PRIMARY KEY CLUSTERED 
(
	[pl_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPositionDim]    Script Date: 8/3/2019 1:47:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPositionDim](
	[p_id] [int] NOT NULL,
	[p_code] [varchar](5) NOT NULL,
	[p_name] [varchar](50) NOT NULL,
	[p_target] [int] NOT NULL,
 CONSTRAINT [PK_tblPositionDim] PRIMARY KEY CLUSTERED 
(
	[p_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTeamDim]    Script Date: 8/3/2019 1:47:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTeamDim](
	[t_id] [int] NOT NULL,
	[t_code] [varchar](5) NOT NULL,
 CONSTRAINT [PK_tblTeamDim] PRIMARY KEY CLUSTERED 
(
	[t_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_team_detail_dim]    Script Date: 8/3/2019 1:47:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************************
NAME:    dbo.v_team_detail_dim
PURPOSE: Create the dbo.v_team_detail_dim view

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     08/02/2019   JJAUSSI       1. Built this table for LDS BC IT240


RUNTIME: 
Approx. 1 min

NOTES:
These are the varioius Extract, Transform, and Load steps needed for the Example Data

LICENSE: This code is covered by the GNU General Public License which guarantees end users
the freedom to run, study, share, and modify the code. This license grants the recipients
of the code the rights of the Free Software Definition. All derivative work can only be
distributed under the same license terms.
 
******************************************************************************************************************/

CREATE VIEW [dbo].[v_team_detail_dim]
AS
SELECT t.t_id
     , t.t_code
     , p.p_id
     , p.p_code
     , p.p_name
     , pl.pl_id
     , pl.pl_name
     , pl.pl_num
  FROM dbo.tblTeamDim AS t
 INNER JOIN dbo.tblPlayerDim AS pl 
    ON t.t_id = pl.t_id 
 INNER JOIN dbo.tblPositionDim AS p
   ON pl.p_id = p.p_id;

GO
/****** Object:  View [dbo].[v_team_sum]    Script Date: 8/3/2019 1:47:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************************
NAME:    dbo.v_team_sum
PURPOSE: Create the dbo.v_team_sum view

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     08/02/2019   JJAUSSI       1. Built this table for LDS BC IT240


RUNTIME: 
Approx. 1 min

NOTES:
These are the varioius Extract, Transform, and Load steps needed for the Example Data

LICENSE: This code is covered by the GNU General Public License which guarantees end users
the freedom to run, study, share, and modify the code. This license grants the recipients
of the code the rights of the Free Software Definition. All derivative work can only be
distributed under the same license terms.
 
******************************************************************************************************************/

CREATE VIEW [dbo].[v_team_sum]
AS

WITH s1 -- Step 1
AS
(
SELECT pl.t_id
     , pl.p_id
     , Count(pl.pl_id) AS p_id_count
     , p.p_target
  FROM dbo.tblPlayerDim AS pl
 INNER JOIN dbo.tblPositionDim AS p
    ON pl.p_id = p.p_id
 GROUP BY pl.t_id
     , pl.p_id
     , p.p_target
)
SELECT s1.t_id
     , t.t_code
     , p.p_id
     , p.p_code
     , p.p_name
     , s1.p_id_count
     , s1.p_target
     , [p_id_count]-[s1].[p_target] AS p_target_var
  FROM s1 
 INNER JOIN dbo.tblTeamDim AS t
    ON s1.t_id = t.t_id
 INNER JOIN dbo.tblPositionDim AS p
    ON s1.p_id = p.p_id;

GO
ALTER TABLE [dbo].[tblPlayerDim]  WITH CHECK ADD  CONSTRAINT [FK_tblPlayerDim_tblPositionDim] FOREIGN KEY([p_id])
REFERENCES [dbo].[tblPositionDim] ([p_id])
GO
ALTER TABLE [dbo].[tblPlayerDim] CHECK CONSTRAINT [FK_tblPlayerDim_tblPositionDim]
GO
ALTER TABLE [dbo].[tblPlayerDim]  WITH CHECK ADD  CONSTRAINT [FK_tblPlayerDim_tblTeamDim] FOREIGN KEY([t_id])
REFERENCES [dbo].[tblTeamDim] ([t_id])
GO
ALTER TABLE [dbo].[tblPlayerDim] CHECK CONSTRAINT [FK_tblPlayerDim_tblTeamDim]
GO
USE [master]
GO
ALTER DATABASE [EXM] SET  READ_WRITE 
GO
