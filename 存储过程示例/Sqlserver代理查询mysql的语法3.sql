USE [N117Andon]
GO
/****** Object:  StoredProcedure [dbo].[web_tightenline_sel]    Script Date: 2023/1/12 15:25:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		zhj
-- Create date:  2022-7-25
-- Description: 拧紧曲线查询
-- =============================================
ALTER PROCEDURE [dbo].[web_tightenline_sel] 
	@station nvarchar(50),		    --工位
	@position nvarchar(50),		    --工件
	@job nvarchar(50),			    --任务号
	@tighten_id nvarchar(50)	    --VIN码
   WITH
   EXEC AS CALLER
AS
begin
--查询拧紧曲线
	select
	   distinct
	   tr.station,
	   tr.position,
	   tr.job,
	   tr.tighten_id,
	   cast(tr.x1 as nvarchar) x1,
	   cast(tr.y1 as nvarchar) y1,
	   cast(tr.y2 as nvarchar) y2
	from
		OPENQUERY(LOCALHOST_DB, 'select * from ecos.tighten_result') tr  
	WHERE
		(@station = '' OR tr.[station] = @station)		 and
		(@position = '' OR tr.[position] = @position)    and
		(@job = '' OR tr.[job] = @job)					 and
		(@tighten_id = '' OR tr.[tighten_id] = @tighten_id)
end