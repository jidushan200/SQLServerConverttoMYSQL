USE [N117Andon]
GO
/****** Object:  StoredProcedure [dbo].[web_tightenquery_sel]    Script Date: 2023/1/12 15:25:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zhj
-- Create date:  2022-7-25
-- Description: 拧紧数据查询
-- =============================================
ALTER PROCEDURE [dbo].[web_tightenquery_sel] 
    @pagesize  INT,         --一页显示多少条
    @page      INT,	        --当前页

	@startdate DATETIME,    --生产日期起始
    @enddate   DATETIME,    --生产日期结束
	@station int,		    --工位
	@position int,		    --工件
	@tighten_status nvarchar(50),--拧紧状态

	@bar_code nvarchar(100)	    --VIN码
   WITH
   EXEC AS CALLER
AS
begin
 --获得总行数
   select
		COUNT(distinct td.id) totalNumber 
  from
		OPENQUERY(LOCALHOST_DB, 'select *from ecos.tighten_data') td  
   WHERE 
		td.bar_code = @bar_code
		or (@bar_code = ''
		    and (@startdate IS NULL OR td.timestamp >= @startdate)
		    and (@enddate IS NULL OR td.timestamp <= @enddate)
		    and (@station = '' OR td.station = @station)
		    and (@position = '' OR td.position = @position)
		    and (@tighten_status = '' OR td.tighten_status = @tighten_status)
			)
--查询拧紧数据
	select DISTINCT 
	    td.id,
		td.station,
		td.position,
		td.job,
		td.bar_code,
		td.ip_device,
		td.prg,
		td.grp,
		td.idcode,
		td.tighten_status,
		td.code,
		td.torque,
		td.angle,
		td.torque_min,
		td.torque_max,
		td.angle_min,
		td.angle_max,
		td.result,
		td.fis,
		td.tighten_id,
		CONVERT (NVARCHAR (100), td.timestamp, 120)
             AS 'timestamp'
	from
		OPENQUERY(LOCALHOST_DB, 'select * from ecos.tighten_data') td  
	WHERE 
		td.bar_code = @bar_code
		or (@bar_code = ''
		    and (@startdate IS NULL OR td.timestamp >= @startdate)
		    and (@enddate IS NULL OR td.timestamp <= @enddate)
		    and (@station = '' OR td.station = @station)
		    and (@position = '' OR td.position = @position)
		    and (@tighten_status = '' OR td.tighten_status = @tighten_status)
			)
	ORDER BY td.id
	OFFSET (@page - 1) * @pagesize ROW
	FETCH NEXT @pagesize ROWS ONLY
end